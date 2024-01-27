with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;

package body Table_Routage is


    procedure Initialiser_Table(Table : in out T_LCA ; Table_File : in out File_Type ) is
        Adresse : T_Adresse_IP;
        Masque : T_Adresse_IP;
        Iface : Unbounded_String;
        Donnee : T_CelluleT;
    begin
        Initialiser(Table);
        loop
            Adresse := Convertir_Adresse_IP(Table_File);
            Masque := Convertir_Adresse_IP(Table_File);
            Iface := To_Unbounded_String(Get_Line(Table_File));
            Trim(Iface, Both);
            Donnee := (Masque, Iface);
            Enregistrer(Table, Adresse, Donnee);
            exit when End_Of_File(Table_File);
        end loop;
    exception
        when End_Error =>
            Put ("Blancs en surplus à la fin du fichier.");
            null;
    end Initialiser_Table;


    procedure Put_table (Table : T_LCA ; Line_Number : Integer) is

        procedure Line_Put (Cle : T_Adresse_IP  ; Donnee : T_CelluleT) is
        begin
            Afficher_Adresse_IP(Cle);
            Afficher_Adresse_IP(Donnee.Masque);
            Put(To_String(Donnee.Iface));
            New_Line;
        end Line_Put;

        procedure Table_Line_Put is new Pour_Chaque(Traiter => Line_Put);

    begin
        Put("table : (ligne ");
        put(Line_Number, 1);
        Put(")");
        New_Line;
        Table_Line_Put(Table);
    end Put_Table;


    function Chercher_table(Table : in T_LCA ; Adresse : in T_Adresse_IP ) return unbounded_String is
        iface : unbounded_String;
        Masque : T_Adresse_IP;
        procedure Chercher_Ligne(Cle : T_Adresse_IP ; Donnee : T_CelluleT) is
        begin
            if (Adresse and Donnee.Masque) = Cle and Donnee.Masque >= Masque then
                Masque := Donnee.Masque;
                iface := Donnee.iface;
            else
                null;
            end if;
        end Chercher_Ligne;

        procedure Chercher_Table_Ligne is new Pour_Chaque(Traiter => Chercher_Ligne);

    begin
        Masque := 0;
        Chercher_Table_Ligne(Table);
        return iface;

    end chercher_table;


    function Route_correspondante(Table : in T_LCA ; Adresse : in T_Adresse_IP ) return T_adresse_IP is
        Adresse_correspondante : T_Adresse_IP := Adresse;
        Masque : T_Adresse_IP;
        procedure Chercher_Ligne(Cle : T_Adresse_IP ; Donnee : T_CelluleT) is
        begin
            if (Adresse and Donnee.Masque) = Cle and Donnee.Masque >= Masque then
                Masque := Donnee.Masque;
                Adresse_correspondante := Cle;
            else
                null;
            end if;
        end Chercher_Ligne;

        procedure Chercher_Table_Ligne is new Pour_Chaque(Traiter => Chercher_Ligne);

    begin
        Masque := 0;
        Chercher_Table_Ligne(Table);
        --Afficher_Adresse_IP(Adresse_correspondante);
        return Adresse_correspondante;

    end Route_correspondante;




end Table_Routage;
