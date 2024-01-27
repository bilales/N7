with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Command_Line;          use Ada.Command_Line;
with Table_Routage ;             use Table_Routage;
with adresse_IP;                use adresse_IP;
with Ada.IO_Exceptions;
with cache_ll;                 use cache_ll;
with Ada.Strings;               use Ada.Strings;
with exceptions;

procedure Routeur_ll is


--Cette procédure gère les commandes à l'execution, si une commande est inconnue l'exception commande_invalide est levée
    procedure Gestion_Arguments(
        cache_size  : in out Integer;
        policy      : in out Unbounded_String;
        Stat        : in out Boolean;
        Name_Table_File  : in out Unbounded_String;
        Name_Paquet_File : in out Unbounded_String;
        Name_Result_File : in out Unbounded_String) is

    commande : Unbounded_String;
    i : integer := 1;

    begin


    While i<=Argument_Count loop
        commande := To_unbounded_String(Argument(i));
        if commande = "-c" then
            cache_size := Integer'Value(Argument(i+1));
            i:=i+2;
        elsif commande = "-p" then
            if Argument(i+1) = "FIFO" or Argument(i+1) = "LRU" or Argument(i+1) = "LFU" then
                Policy := To_Unbounded_String(Argument(i+1));
            else    
                Name_Paquet_File := To_Unbounded_String(Argument(i+1));
            end if;
            i := i+2;
        elsif commande = "-s" then
            stat := True;
            i:=i+1;
        elsif commande = "-S" then
            stat := False;
            i:=i+1;
        elsif commande = "-t" then
            Name_Table_File := To_Unbounded_String(Argument(i+1));
            i:= i+2;
        elsif commande = "-r" then
            Name_Result_File := To_Unbounded_String(Argument(i+1));
            i:=i+2;
        else
            raise exceptions.commande_invalide;
        end if;
    end loop ;
    Exception
        when others =>
            raise exceptions.commande_invalide;
    end Gestion_Arguments;







    -- Début programme


Paquet_File : File_Type;
Result_File : File_Type;
Table_File : File_Type;
Table : TableRoutage_LCA.T_LCA;
adresse : T_Adresse_IP;
Iface : Unbounded_String;
cache_size : integer:=10;
policy : unbounded_String := To_Unbounded_String("FIFO");
stat : Boolean:= True;
Name_Table_File : unbounded_String := To_Unbounded_String("table.txt");
Name_Paquet_File :unbounded_String := To_Unbounded_String("paquets.txt");
Name_Result_File : unbounded_String := To_Unbounded_String("resultats.txt");
Line_Number : Integer := 0;
commande_cache: unbounded_String;
continuer : Boolean := True;
cache : T_cache;
Donnee_Table :T_CelluleT;
Adresse_correspondante : T_Adresse_IP;
Adresse_trouvee : boolean;

begin 

Gestion_Arguments(cache_size,policy,Stat,Name_Table_File, Name_Paquet_File, Name_Result_File); --gère les les lignes de commandes


Initialiser_Cache(cache, cache_size, Policy);
open(Paquet_File, In_File, To_String(Name_Paquet_File));
create(Result_File, out_File, To_String(Name_Result_File));
open(Table_File, in_File, To_String(Name_Table_File));
Initialiser_Table(Table,Table_File);
close(Table_File);


while not End_Of_File(Paquet_File) and continuer loop

    begin                       --On crée un block pour ne pas sortir de la boucle si une exception est levée



        Line_Number := Integer(Line(Paquet_File));
        Adresse := Convertir_Adresse_IP(Paquet_File);
        Ecrire_Adresse_IP(Result_File, Adresse);
        Chercher_Cache(cache, Adresse, Iface, Adresse_trouvee);
        if Adresse_trouvee then
            Put(Result_File, Iface);
            New_Line(Result_File);
            skip_line(Paquet_File);
        else
            Iface := Chercher_Table(Table, Adresse);
            Adresse_correspondante := Route_correspondante(Table,Adresse);
            Donnee_Table := TableRoutage_LCA.La_Donnee(Table, Adresse_correspondante);
            Ajouter_Route_Cache(cache, Adresse, Donnee_Table.Iface, Donnee_Table.masque, Policy, 0);
            Put(Result_File, Iface);
            New_Line(Result_File);
            skip_line(Paquet_File);
        end if;

    

        exception
                --Les commandes de cache en chaîne de caracètres provoqueront une erreur DATA_ERROR
            when DATA_ERROR =>
                commande_cache:=Get_line(Paquet_File);
                trim(commande_cache,both);

                if commande_cache="table" then    -- Si 'Table' est trouvé dans le fichier paquet, on affiche la table de routage
                    Put_Table(Table,Line_Number);

                elsif commande_cache="fin" then   -- Si 'Fin' est trouvé dans le fichier paquet, on arrête le programme
                    Continuer:= False;
                elsif commande_cache="cache" then
                    Afficher_cache(cache, Policy, Line_Number);
                end if;
            when ADA.IO_EXCEPTIONS.END_ERROR =>   --il y a une erreur sans doute due à la dernière execution de "skip_line(Paquet_File)", cela n'impacte pas le fonctionnement du programme
                null;
                --S'il s'agit d'une autre erreur alors le fichier paquet n'a pas la bonne structure
            when others =>
                Put("Structure incorrecte du paquet à la ligne" & Integer'Image(Line_Number));
                Continuer := False;
    end;
end loop;


if stat then
    Afficher_Statistiques(cache);
end if;

close(Paquet_File);
close(Result_File);
--TableRoutage_LCA.vider(Table);


end Routeur_ll;