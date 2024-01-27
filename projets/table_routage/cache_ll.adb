with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

package body cache_ll is 

    --sous programme pour la politique LFU, qui permet de localiser le minimum de fréquence associée à une adresse dans le cache

    function Min_Cache(LCA : in cache_LCA.T_LCA) return T_Adresse_IP is 
        MinFreq_Cellule : T_Cellule;
        MinFreq : Integer;
        Adresse : T_Adresse_IP;
        Min_Adresse : T_Adresse_IP;
    begin
        Indice_Cellule(Lca, 0, Min_Adresse, MinFreq_Cellule);
        MinFreq := MinFreq_Cellule.frequence;
        for i in 1..(cache_LCA.Taille(Lca)-1) loop
            cache_LCA.Indice_Cellule(Lca, i, Adresse, MinFreq_Cellule);
            if MinFreq_Cellule.frequence < MinFreq then
                MinFreq := MinFreq_Cellule.frequence;
                Min_Adresse := Adresse;
            end if;
        end loop;
        return Min_Adresse;
    end Min_Cache;



    -- Partie importante


    procedure Initialiser_Cache(cache : in out T_cache; Taille : in integer; Policy: in Unbounded_String) is
    begin
        cache_LCA.Initialiser(cache.LCA);
        cache.Taille := Taille;
        cache.Policy := Policy;
        cache.Nbr_Appels := 0;
    end Initialiser_Cache;





    procedure Chercher_Cache(cache : in out T_cache; adresse : in T_Adresse_IP; Iface: out unbounded_String; Adresse_trouvee : out boolean) is
    Donnee : T_cellule;
    Policy : constant unbounded_String := cache.Policy;
    begin

        if  cache_LCA.Cle_Presente(cache.LCA, adresse) then
            Donnee := cache_LCA.La_Donnee(cache.LCA, adresse);
            Iface := Donnee.Iface;
            Adresse_trouvee := True;
            Cache.Nbr_Appels := Cache.Nbr_Appels + 1;
            if Policy =  To_Unbounded_String("LFU") then
                Donnee.frequence := Donnee.frequence +1;
                cache_LCA.Enregistrer(cache.Lca, Adresse, Donnee);             -- mise à jour de Donnee via la procédure Enregistrer qui met à jour la donnee si la clé est déjà présente
            else
                cache_LCA.Supprimer_debut(cache.LCA);
                cache_LCA.Enregistrer(cache.LCA, adresse, Donnee);
            end if;
            Adresse_trouvee := True;
        else
            Adresse_trouvee := False;
        end if;
    end Chercher_Cache;




    procedure Ajouter_Route_Cache(cache : in out T_cache ; Adresse : in T_Adresse_IP ; Iface : in Unbounded_String; masque : T_Adresse_IP ;Policy : in Unbounded_String;freq : integer) is
    Adresse_supprimee : T_Adresse_IP;
    Donnee : T_cellule; 
    begin
        Donnee := (Iface, masque, freq);
        if cache_LCA.Taille(Cache.LCA) = cache.Taille then
            if Policy = To_Unbounded_String("LFU") then
                Adresse_Supprimee := Min_Cache(Cache.Lca);
                cache_LCA.supprimer(cache.LCA, Adresse_supprimee);
            else
                cache_LCA.Supprimer_debut(cache.LCA);
            end if;
        end if;
        cache_LCA.Enregistrer(cache.LCA, Adresse, Donnee);
    end Ajouter_Route_Cache;




    procedure Afficher_Statistiques (Cache : in T_Cache) is
    begin
        Ada.Text_IO.Put_Line("Nombre d'appels : " & Integer'Image(Cache.Nbr_Appels));
    end Afficher_Statistiques;


    procedure Afficher_cache (Cache : in T_Cache; Politique : in Unbounded_String; Line_Number : integer) is

        procedure Afficher_Liste (Cle: T_Adresse_IP; Donnee : T_Cellule) is
        begin
            Afficher_Adresse_IP(Cle);
            Put("     ");
            Afficher_Adresse_IP(Donnee.masque);
            Put("     ");
            Put(Donnee.Iface);
            if Politique = To_Unbounded_String("LFU") then
                Put(" : " & Integer'Image(Donnee.frequence));
            end if;
            New_Line;
        end Afficher_Liste;

        procedure Afficher_Cache_Liste is new cache_LCA.Pour_Chaque(Traiter => Afficher_Liste);

    begin
        if  cache_LCA.Est_Vide(Cache.Lca) then
            Put_Line("Cache vide");
        else
            Put("cache : (ligne ");
            Put(Line_Number,1);
            Put(" )");
            if Politique = To_Unbounded_String("LFU") then
                Put("  - fréquence d'appel");
            end if;
            New_Line;
            Afficher_Cache_Liste(Cache.Lca);
        end if;
    end Afficher_cache;


    function Taille_cache(cache : in T_cache) return integer is
    begin
        return Taille(cache.lca);
    end Taille_cache;



    

end Cache_ll;
