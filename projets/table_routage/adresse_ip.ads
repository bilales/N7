with Ada.Text_IO;      use Ada.Text_IO;

package adresse_IP is

    Type T_Adresse_IP is mod 2**32;

    -- Afficher une adresse IP (format XXX.XXX.XXX.XXX)
    --
    -- Paramètres :
    --      adresse_IP : adresse IP à afficher
    --
    -- Pre / Post : aucune.
    procedure Afficher_Adresse_IP (Adresse : in T_Adresse_IP);

    --Convertir une adresse IP (format XXX.XXX.XXX.XXX) en T_Adresse_IP 
    --
    -- Paramètres :
    --      adresse : adresse IP à convertir
    --
    -- Pre / Post : aucune.
    function Convertir_Adresse_IP (Fichier : in File_Type) return T_Adresse_IP;

    --Ecrire une adresse IP dans un fichier 
    --
    --Paramètres :
    --      fichier :in out type_File
    --      Adresse: in T_Adresse_IP
    -- Pre / Post : aucune.
    procedure Ecrire_Adresse_IP (fichier :in out File_Type ; Adresse: in T_Adresse_IP);
    
end adresse_IP;