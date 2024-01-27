with adresse_IP;                 use adresse_IP;
with LCA;
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Strings;               use Ada.Strings;

package Table_Routage is

    Type T_CelluleT is record
        Masque : T_Adresse_IP;
        Iface : Unbounded_String;
    end record;

    package Tableroutage_LCA is new LCA (T_cle => T_Adresse_IP, T_Donnee => T_CelluleT);
    use Tableroutage_LCA;

    -- Affiche la table de routage et le numéro de la ligne de la commande dans le cache
    --
    -- Paramètres :
    --      Table : Table de routage à afficher.
    --      Line_number : Numéro de la ligne d'appel de la commande dans le fichier de paquetage.
    --
    -- Pre / Post : Aucune.
    procedure Put_Table (Table : T_LCA ; Line_Number : Integer);

    -- Cherche une adresse IP dans la table et renvoie l'interface associée (masque le plus grand possible)
    --
    -- Paramètres :
    --      Table : Table de routage dans laquelle chercher
    --      Adresse : Adresse IP à comparer.
    --
    -- Pre / Post : Aucune.
    function Chercher_table(Table : T_LCA ; Adresse : T_Adresse_IP) return Unbounded_String;

    -- Initialise la table de routage avec les valeur dans le fichier Fichier_Table.
    --
    -- Paramètres :
    --      Table : Table de routage à initialiser.
    --      Table_file : Fichier contenant les valeurs à initialiser.
    --
    -- Pre / Post : Aucune.
    procedure Initialiser_Table(Table : in out T_LCA ; Table_File : in out File_Type );

    -- Initialise la table de routage avec les valeur dans le fichier Fichier_Table.
    --
    -- Paramètres :
    --      Table : Table de routage à initialiser.
    --      Table_file : Fichier contenant les valeurs à initialiser.
    --
    -- Pre / Post : Aucune.
    function Route_correspondante(Table : in T_LCA ; Adresse : in T_Adresse_IP ) return T_adresse_IP;


end Table_Routage;