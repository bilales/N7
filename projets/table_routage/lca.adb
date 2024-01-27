--with Ada.Text_IO;    use Ada.Text_IO;
with SDA_Exceptions; use SDA_Exceptions;
with Ada.Unchecked_Deallocation;

package body LCA is

    procedure Free is new Ada.Unchecked_Deallocation
       (Object => T_Cellule, Name => T_LCA);

    procedure Initialiser (Sda : out T_LCA) is
    begin
        Sda := null;
    end Initialiser;

    function Est_Vide (Sda : T_LCA) return Boolean is
    begin
        return Sda = null;
    end Est_Vide;

    function Taille (Sda : in T_LCA) return Integer is
		Aux : T_LCA := Sda;
		Taille : Integer := 0;
	begin
		while Aux /= null loop
			Taille := Taille + 1;
			Aux := Aux.All.Suivant;
		end loop;
		return Taille;
	end Taille;

    procedure Enregistrer(Sda : in out T_LCA; Cle : in T_Cle; Donnee : in T_Donnee) is

    Nouvelle_Cellule : T_LCA;
    begin
        if Sda = null then
            Nouvelle_Cellule             := new T_Cellule;
            Nouvelle_Cellule.all.Cle     := Cle;
            Nouvelle_Cellule.all.Donnee  := Donnee;
            Nouvelle_Cellule.all.Suivant := null;
            Sda                          := Nouvelle_Cellule;
        elsif Sda.all.Cle = Cle then
            Sda.all.Donnee := Donnee;
        else
            Enregistrer (Sda.all.Suivant, Cle, Donnee);
        end if;

    end Enregistrer;

    function Cle_Presente (Sda : in T_LCA; Cle : in T_Cle) return Boolean is
    begin
        if Sda = null then
            return False;
        elsif Sda.all.Cle = Cle then
            return True;
        else
            return Cle_Presente (Sda.all.Suivant, Cle);
        end if;
    end Cle_Presente;

    function La_Donnee (Sda : in T_LCA; Cle : in T_Cle) return T_Donnee is
    begin
        if Sda = null then
            raise Cle_Absente_Exception;
        elsif Sda.all.Cle = Cle then
            return Sda.all.Donnee;
        else
            return La_Donnee (Sda.all.Suivant, Cle);
        end if;
    end La_Donnee;

    procedure Supprimer (Sda : in out T_LCA; Cle : in T_Cle) is
        Nouvelle_sda : T_LCA;
    begin
        if Sda = null then
            raise Cle_Absente_Exception;
        elsif Sda.all.Suivant = null and Sda.all.Cle = Cle then
            Free (Sda);
        elsif Sda.all.Suivant /= null and Sda.all.Cle = Cle then
            Nouvelle_sda := Sda;
            Sda          := Sda.all.Suivant;
            Free (Nouvelle_sda);
        else
            Supprimer (Sda.all.Suivant, Cle);
        end if;
    end Supprimer;

    procedure Vider (Sda : in out T_LCA) is

    begin
        if Sda /= null then
            Vider (Sda.all.Suivant);
            Free (Sda);
        else
            raise Cle_Absente_Exception;
        end if;
    end Vider;

    procedure Pour_Chaque (Sda : in T_LCA) is
    begin
        if Sda = null then
            null;
        else
            Traiter (Sda.all.Cle, Sda.all.Donnee);
            Pour_Chaque (Sda.all.Suivant);
        end if;
    exception
        when others =>
            null;
    end Pour_Chaque;


    procedure Supprimer_debut (Sda : in out T_LCA) is
		Aux : T_LCA := Sda;
	begin
		if Sda = null then
			raise Lca_Vide;
		else
			Sda := Sda.All.Suivant;
			Free(Aux);
		end if;
	end Supprimer_debut;

    --Permet d'accéder à la clé et à la donnée souhaité en fonction de l'indice, une procédure similaire à celle d'accéder à l'élément i d'un tableau
    procedure Indice_Cellule (Sda : in T_LCA; Indice : in Integer; Cle : out T_Cle; Donnee : out T_Donnee) is
		Aux : T_LCA := Sda;
		Incrementeur : Integer := 0;
	begin
		while Incrementeur < Indice loop
			Aux := Aux.All.Suivant;
			Incrementeur := Incrementeur + 1;
		end loop;

		Cle := Aux.All.Cle;
		Donnee := Aux.All.Donnee;
	end Indice_Cellule;

    
    
end LCA;
