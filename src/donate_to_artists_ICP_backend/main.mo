import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Map "mo:map/Map";
import Set "mo:map/Set";
import Types "./types";

shared ({ caller }) actor class Plataforma(admins : [Principal]) {

    public type Usuario = Types.Usuario;
    public type Artista = Types.Artista;
    public type Uid = Nat;
    public type Aid = Nat;

    public type RegistroArtistaForm = Types.RegistroArtistaForm;

    stable var actualUid : Nat = 0;
    stable var actualAid : Nat = 0;

    func generarUid() : Nat {
        actualUid += 1;
        actualUid;
    };

    func generarAid() : Nat {
        actualAid += 1;
        actualAid;
    };

    let usuarios = Map.new<Principal, Usuario>();
    let artistas = Map.new<Principal, Artista>();
    let admins = Set.new<Principal>();

    let artistasIngresantes = Map.new<Principal, RegistroArtistaForm>();

    func esUsuario(p : Principal) : Bool {
        return switch (Map.get<Principal, Usuario>(usuarios, Map.phash, p)) {
            case null { false };
            case _ { true };
        };
    };

    func esAdmin(p : Principal) : Bool {
        Set.has<Principal>(admins, Map.phash, p);
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
        actualUid;
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

    public shared ({ caller }) func aprobarRegistroDeArtista(solicitante : Principal) : async Aid {
        assert (esAdmin(caller));
        let usuario = Map.get<Principal, Usuario>(usuarios, Map.phash, solicitante);
        switch usuario {
            case null { assert false; 0 };
            case (?usuario) {
                let solicitud = Map.get<Principal, RegistroArtistaForm>(artistasIngresantes, Map.phash, solicitante);
                switch (solicitud) {
                    case null { assert false; 0 };
                    case (?solicitud) {
                        let nuevoArtista: Artista = {
                            principal = solicitante;
                            aid = generarAid();
                            pseudonimo = solicitud.pseudonimo;
                            nombreDePila = solicitud.nombreDePila;
                            redesSociales = solicitud.redesSociales;
                            email = usuario.email;
                            fotoArtistica = solicitud.fotoArtistica;
                            propinasRecibidas = 0;
                            seguidores = 0;
                        };
                        ignore Map.put<Principal, Artista>(artistas, Map.phash, solicitante, nuevoArtista);
                        ignore Map.remove<Principal, RegistroArtistaForm>(artistasIngresantes, Map.phash, solicitante);
                        actualAid;
                    };
                };
            };
        };

    };

};
