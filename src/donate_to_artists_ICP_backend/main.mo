import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Map "mo:map/Map";
import Set "mo:map/Set";
import Types "./types";

shared ({ caller }) actor class Plataforma(admins : [Principal]) {

    public type Usuario = Types.Usuario;
    public type Uid = Nat;

    stable var currentUid : Nat = 0;
    func generateUid() : Nat {
        currentUid += 1;
        currentUid;
    };

    let usuarios = Map.new<Principal, Usuario>();
    let admins = Set.new<Principal>();

    func esUsuario(p : Principal) : Bool {
        return switch (Map.get<Principal, Usuario>(usuarios, Map.phash, p)) {
            case null { false };
            case _ { true };
        };
    };

    public shared ({ caller }) func registrarse(nick : Text, email : Text, foto : ?Blob) : async Uid {
        assert (not Principal.isAnonymous(caller));
        assert (not esUsuario(caller));
        let nuevoUsuario : Usuario = {
            uid = generateUid();
            nick;
            email;
            foto;
        };
        ignore Map.put<Principal, Usuario>(usuarios, Map.phash, caller, nuevoUsuario);
        currentUid;
    };



};
