module {
    public type Usuario = {
        principal : Principal;
        uid : Nat;
        nick : Text;
        email : Text;
        foto : ?Blob;
    };

    public type RegistroArtistaForm = {
        pseudonimo : Text;
        nombreDePila : Text;
        redesSociales : [Text];
        fotoArtistica : ?Blob;
    };

    public type Artista = {
        principal : Principal;
        aid : Nat;
        pseudonimo : Text;
        nombreDePila : Text;
        redesSociales : [Text];
        email : Text;
        fotoArtistica : ?Blob;
        propinasRecibidas : Nat;
        seguidores : Nat;
    };

};
