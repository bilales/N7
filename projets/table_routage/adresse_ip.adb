with Ada.Integer_Text_IO;    use Ada.Integer_Text_IO;


package body adresse_IP is

    procedure Afficher_Adresse_IP(Adresse : in T_Adresse_IP) is
    begin
        for i in 0..2 loop
            Put(Natural (Adresse/256**(3-i) mod 256), 1);
            Put(".");
        end loop;
        put(Natural (Adresse mod 256), 1);
        Put(" ");
    end Afficher_Adresse_IP;



    function Convertir_Adresse_IP(Fichier : in File_Type) return T_Adresse_IP is
        Octet : Integer;
        point : Character;
        Adresse : T_Adresse_IP := 0;
    begin
        for i in 0..3 loop
            Get(Fichier, Octet);
            Adresse :=  T_Adresse_IP(Octet) + Adresse*256;
            if i<3 then                                 --pour consommer le point et il y a 3 point à consommez
                Get(Fichier, point);
            end if;
        end loop;
        return Adresse;
    end Convertir_Adresse_IP;

    procedure Ecrire_Adresse_IP (fichier :in out File_Type; Adresse: in T_Adresse_IP) is

        procedure  Convertir_Inverse_Adresse_IP(Adresse : in out T_Adresse_IP; Octet_integer : in out integer) is
        OCTET: constant T_Adresse_IP := 2 ** 8;
        begin
            Octet_integer := Natural (Adresse mod OCTET);
            Adresse := Adresse / OCTET;
        end Convertir_Inverse_Adresse_IP;

    o1,o2,o3,o4 : Integer := 0;
    Adresse_aux :T_Adresse_IP := Adresse;
    begin
    Convertir_Inverse_Adresse_IP(Adresse_aux, o4);
    Convertir_Inverse_Adresse_IP(Adresse_aux, o3);
    Convertir_Inverse_Adresse_IP(Adresse_aux, o2);
    Convertir_Inverse_Adresse_IP(Adresse_aux, o1);
    Put(fichier ,o1,1);
    Put(fichier,".");
    Put(fichier ,o2,1);
    Put(fichier,".");
    Put(fichier ,o3,1);
    Put(fichier,".");
    Put(fichier ,o4,1);
    Put(fichier, " ");
    end Ecrire_Adresse_IP;

end adresse_IP;
