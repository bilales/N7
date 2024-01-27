with Ada.Strings;                 use Ada.Strings;
with LCA;
with adresse_IP;                   use adresse_IP;
with Ada.Strings.Unbounded;       use Ada.Strings.Unbounded;




package cache_ll is 


    type T_cache is limited private;
    Type T_cellule is limited private;



-- Initialise le cache
    --
    -- Paramètres :
    --              cache : in out T_cache cache à initialiser
    --              Taille; in integer 

    --
    -- Pre / Post : aucune.
procedure Initialiser_Cache(cache : in out T_cache; Taille : in integer; Policy : in Unbounded_String);



-- Ajoute un route au cache
    --
    -- Paramètres :
    --              cache : in out T_cache cache à initialiser
    --              Adresse : in T_Adresse_IP adresse à ajouter 
    --              Iface : in Unbounded_String interface à ajouter
    --              masque : T_Adresse_IP à ajouter
    --              freq : integer à ajouter (toujours nul pour la politique LFU)
    --
    --

    -- Pre / Post : aucune.
procedure Ajouter_Route_Cache(cache : in out T_cache ; Adresse : in T_Adresse_IP ; Iface : in Unbounded_String; masque : T_Adresse_IP ;Policy : in  Unbounded_String;freq : integer);



-- Cherche un route au cache
    --
    -- Paramètres :
    --              cache : in out T_cache; cache à chercher
    --              Adresse : in T_Adresse_IP; adresse à chercher 
    --              Iface : in Unbounded_String; interface à retourner si l'adresse est dans le cache
    --
    --

    -- Pre / Post : aucune.
procedure Chercher_Cache(cache : in out T_cache; adresse : T_Adresse_IP; iface : out unbounded_String; Adresse_trouvee : out boolean);



-- Affiche le cache
    --
    -- Paramètres :
    --              cache : in out T_cache cache à afficher
    --              Politique :unbounded_String, l'affichage dépend de la politique 
    --              Line_Number : integer, ligne à laquelle il est demandé d'afficher le cache
    --
    --

    -- Pre / Post : aucune.
procedure Afficher_cache(cache : in T_cache; Politique :unbounded_String; Line_Number : integer);


-- Ajoute le nombre d'appels du cache
    --
    -- Paramètres :
    --              cache : in out T_cache cache dont les statistiques d'affichent;

    --
    --

    -- Pre / Post : aucune.
procedure Afficher_Statistiques(cache : in T_cache);

function Taille_cache(cache : in T_cache) return integer;




private

    type T_Cellule is record
        Iface : Unbounded_String;
        Masque : T_Adresse_IP;
        frequence : integer;        -- concerne uniquement la politique LFU
    end record;


    package cache_LCA is new LCA (T_cle => T_Adresse_IP, T_Donnee => T_cellule);
    use cache_LCA;

    type T_cache is record
        LCA : cache_LCA.T_LCA;
        Taille : integer;
        Policy : Unbounded_String;
        Nbr_Appels : integer;       --Nombre d'appels du cache
    end record;



end cache_ll;