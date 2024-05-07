module {
    public type Uid = Text; //Usuario id
    public type Aid = Text; //Artista id
    public type Pid = Text; //Proyecto id

    public type Usuario = {
        principal : Principal;
        uid : Text;
        nick : Text;
        email : Text;
        foto : ?Blob;
        proyectosVotados : [Pid];
    };

    public type RegistroArtistaForm = {
        pseudonimo : Text;
        nombreDePila : Text;
        redesSociales : [Text];
        emailArtistico : Text;
        fotoArtistica : ?Blob;
    };

    public type Artista = {
        principal : Principal;
        aid : Text;
        pseudonimo : Text;
        nombreDePila : Text;
        redesSociales : [Text];
        emailArtistico : Text;
        fotoArtistica : ?Blob;
        propinasRecibidas : Nat;
        seguidores : Nat;
        proyectos : [Pid]
    };

    public type Item = {
        item: Text;
        porcentaje: Nat;
    };

    public type FinanciamientoForm = {
        owner: Principal;
        nombreProyecto: Text;
        descripcionCorta: Text;
        genero: Text;
        linkDemo: Text;
        fondosRequeridos: Nat;
        distribucionDeLosFondos: [Item];
        plasoEstimadoEnMeses: Nat;
    };

    public type Estado = {
        #Aprobado;
        #Tokenizado;
        #ProduccionIniciada;
        #ProduccionALaEsperaDeFondos;
        #ProduccionConcluida;
        #Finalizado;
    };

    public type Proyecto = {
        owner: Principal;
        nombreProyecto: Text;
        descripcionCorta: Text;
        genero: Text;
        linkDemo: Text;
        fondosRequeridos: Nat;
        distribucionDeLosFondos: [Item];
        plasoEstimadoEnMeses: Nat;
        fechaAprobacion: Int;
        fondosObtenidos: Nat;
        votos : Nat;
        estado: Estado;
    }

};
