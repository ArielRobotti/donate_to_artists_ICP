import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Map "mo:map/Map";
import { thash; phash } "mo:map/Map";
import Time "mo:base/Time";
import Array "mo:base/Array";
import Set "mo:map/Set";
import Types "./types";

shared ({ caller }) actor class _Plataforma(_admins : [Principal]) {

    stable let deployer = caller;

    public type Usuario = Types.Usuario;
    public type Artista = Types.Artista;
    public type Uid = Types.Uid; //Usuario id
    public type Aid = Types.Aid; //Artista id
    public type Pid = Types.Pid; //Proyecto id

    public type RegistroArtistaForm = Types.RegistroArtistaForm;
    public type FinanciamientoForm = Types.FinanciamientoForm;
    public type Proyecto = Types.Proyecto;

    stable var actualUid : Nat = 0;
    stable var actualAid : Nat = 0;
    stable var actualPid : Nat = 0;

    func generarUid() : Text {
        actualUid += 1;
        "U" # Nat.toText(actualUid);
    };

    func generarAid() : Text {
        actualAid += 1;
        "A" # Nat.toText(actualAid);
    };

    func generarPid() : Text {
        actualPid += 1;
        "P" # Nat.toText(actualPid);
    };

    stable let usuarios = Map.new<Principal, Usuario>();
    stable let artistas = Map.new<Principal, Artista>();
    stable let admins = Set.new<Principal>();

    for (i in _admins.vals()) {
        ignore Set.put<Principal>(admins, Map.phash, i);
    };

    stable let artistasIngresantes = Map.new<Principal, RegistroArtistaForm>();
    stable let proyectosIngresantes = Map.new<Principal, FinanciamientoForm>();

    stable let proyectosAprobados = Map.new<Pid, Proyecto>();

    func esUsuario(p : Principal) : Bool {
        return switch (Map.get<Principal, Usuario>(usuarios, Map.phash, p)) {
            case null { false };
            case _ { true };
        };
    };

    func esArtista(p : Principal) : Bool {
        return switch (Map.get<Principal, Artista>(artistas, Map.phash, p)) {
            case null { false };
            case _ { true };
        };
    };

    func esAdmin(p : Principal) : Bool {
        Set.has<Principal>(admins, Map.phash, p);
    };

    public shared ({ caller }) func agregarAdmin(p : Principal) : async Bool {
        assert (esAdmin(caller));
        ignore Set.put<Principal>(admins, Map.phash, p);
        true;
    };

    public shared ({ caller }) func removerAdmin(p : Principal) : async Bool {
        assert (deployer == caller and p != caller);
        ignore Set.remove<Principal>(admins, Map.phash, p);
        true;
    };

    public shared ({ caller }) func registrarse(nick : Text, email : Text, foto : ?Blob) : async Uid {
        assert (not Principal.isAnonymous(caller));
        assert (not esUsuario(caller));
        let nuevoUsuario : Usuario = {
            principal = caller;
            uid = generarUid();
            nick;
            email;
            foto;
        };
        ignore Map.put<Principal, Usuario>(usuarios, Map.phash, caller, nuevoUsuario);
        "U" # Nat.toText(actualUid);
    };

    public shared ({ caller }) func registrarseComoArtista(_init : RegistroArtistaForm) : async Text {
        assert (not Principal.isAnonymous(caller));
        let usuario = Map.get<Principal, Usuario>(usuarios, Map.phash, caller);
        switch usuario {
            case null { return "Debe registrarse como usuario previamente" };
            case (?usuario) {
                if (Map.has<Principal, RegistroArtistaForm>(artistasIngresantes, Map.phash, caller)) {
                    return "Usetd ya tiene pendiente de aprobación una solicitud de registro como artista";
                };
                ignore Map.put<Principal, RegistroArtistaForm>(artistasIngresantes, Map.phash, caller, _init);
                return "Solicitud de registro como artista ingresada exitosamente";
            };
        };
    };

    public shared ({ caller }) func verArtistasIngresantes() : async [(Principal, RegistroArtistaForm)] {
        assert (esAdmin(caller));
        Iter.toArray(Map.entries<Principal, RegistroArtistaForm>(artistasIngresantes));
    };

    public shared ({ caller }) func aprobarRegistroDeArtista(solicitante : Principal) : async Aid {
        assert (esAdmin(caller));
        let usuario = Map.get<Principal, Usuario>(usuarios, Map.phash, solicitante);
        switch usuario {
            case null { assert false; "" };
            case (?usuario) {
                let solicitud = Map.remove<Principal, RegistroArtistaForm>(artistasIngresantes, Map.phash, solicitante);
                switch (solicitud) {
                    case null { assert false; "" };
                    case (?solicitud) {
                        let nuevoArtista : Artista = {
                            solicitud with 
                            principal = solicitante;
                            aid = generarAid();
                            propinasRecibidas = 0;
                            seguidores = 0;
                            proyectos = [];
                        };
                        ignore Map.put<Principal, Artista>(artistas, Map.phash, solicitante, nuevoArtista);
                        "A" # Nat.toText(actualAid);
                    };
                };
            };
        };
    };

    //-------------------- Funcion para armar galeria de artistas en el front ----------------------------

    public func verArtistas() : async [Artista] {
        Iter.toArray(Map.vals<Principal, Artista>(artistas));
    };

    //------------------- Solicitud de financiamiento de produccion musical  -----------------------------

    public shared ({ caller }) func solicitudDeFinanciamiento(_init : FinanciamientoForm) : async Text {
        assert (esArtista(caller));
        switch (Map.get<Principal, FinanciamientoForm>(proyectosIngresantes, phash, caller)) {
            case (?solicitudPrevia) {
                return "Usted tiene pendiente una solicitud para el proyecto " # solicitudPrevia.nombreProyecto;
            };
            case null {
                ignore Map.put<Principal, FinanciamientoForm>(proyectosIngresantes, phash, caller, _init);
                return "Su solicitud fue ingresada con éxito. En los proximos dias será contactado via email";
            };
        };
    };

    //----------------- Ver solicitudes de financiamiento ---------------------------------------------------

    public shared ({ caller }) func verSolicitudesFinanciamiento() : async [(Principal, FinanciamientoForm)] {
        assert (esAdmin(caller));
        let iterEntries = Map.entries<Principal, FinanciamientoForm>(proyectosIngresantes);
        Iter.toArray<(Principal, FinanciamientoForm)>(iterEntries);
    };
    //----------------- Aprobación y rechazo de financiamiento de produccion musical ----------------------------------

    public shared ({ caller }) func aprobarFinanciamiento(p : Principal) : async Pid {
        assert (esAdmin(caller));
        let solicitud = Map.remove<Principal, FinanciamientoForm>(proyectosIngresantes, phash, p);
        switch (solicitud) {
            case null { assert false; "" };
            case (?solicitud) {
                let artista = Map.get<Principal, Artista>(artistas, phash, p);
                switch artista {
                    case null { assert false; "" };
                    case (?artista) {
                        let proyecto : Proyecto = {
                            solicitud with
                            fechaAprobacion = Time.now();
                            fondosObtenidos = 0;
                            estado = #Aprobado;
                        };
                        let id = generarPid();
                        ignore Map.put<Pid, Proyecto>(proyectosAprobados, thash, id, proyecto);
                        let setProyectos = Set.fromIter<Pid>(artista.proyectos.vals(), thash);
                        ignore Set.put<Pid>(setProyectos, thash, id);
                        let proyectos =  Set.toArray<Pid>(setProyectos);
                        ignore Map.put<Principal, Artista>(artistas, phash, p, {artista with proyectos});
                        id;
                     };
                };
            };
        };
    };

    public shared ({caller}) func rechazarFinanciamiento(p: Principal ): async () {
        assert(esAdmin(caller));
        ignore Map.remove<Principal, FinanciamientoForm>(proyectosIngresantes, phash, p);
    };

    //--------------------------------------------------------------------------------------------------------

};
