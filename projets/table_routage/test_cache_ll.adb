with Cache_ll;                 use Cache_ll;
with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO; use Ada.Text_IO.Unbounded_IO;

procedure test_Cache_LL is
    Cache : T_Cache;
    iface : Unbounded_String;
    Adresse_trouvee : boolean;

begin
    Initialiser_Cache(Cache, 2, To_Unbounded_String("FIFO"));
    pragma assert (Taille_cache(Cache) = 0);
    Put_Line("Attendu après initialisation :");
    Put_Line("cache : (ligne 10)");
    Put_Line("Cache vide");
    Put_Line("Obtenu :");
    Afficher_cache(Cache,To_Unbounded_String("FIFO"), 10); New_Line;
    Put_Line("Initialisation : OK");
    
    New_Line;
    Put_Line(" ||||| Test LRU (taille : 2)  |||||"); 
    New_Line;

    Initialiser_Cache(Cache, 2, To_Unbounded_String("LRU"));
    Ajouter_Route_Cache(Cache, 0, To_Unbounded_String("eth0"),0,To_Unbounded_String("LRU"),0);

    Put_Line("Attendu après ajout de 0.0.0.0 :");
    Put_Line("cache : (ligne 100)");
    Put_Line("0.0.0.0  0.0.0.0  eth0");
    Put_Line("Obtenu :");
    Afficher_cache(Cache,To_Unbounded_String("LRU"), 100); 
    New_Line;

    Chercher_Cache(Cache, 0, Iface,Adresse_trouvee);
    pragma assert(Adresse_trouvee);
    Put_Line("Attendu après recherche de 0.0.0.0 : eth0");
    Put("Obtenu : "); 
    Put_Line(iface); 
    New_Line;

    Put_Line("Politique LRU : OK!!"); 
    New_Line;



    Put_Line("||||| Test FIFO (taille : 2) |||||"); 
    New_Line;

    Initialiser_Cache(Cache, 2, To_Unbounded_String("FIFO"));
    Ajouter_Route_Cache(Cache, 0, To_Unbounded_String("eth0"),0, To_Unbounded_String("FIFO"),0);
    Ajouter_Route_Cache(Cache, 1, To_Unbounded_String("eth1"),0,To_Unbounded_String("FIFO") ,0);

    Put_Line("Cache :");
    Afficher_cache(Cache,To_Unbounded_String("FIFO"), 100); 
    New_Line;

    Chercher_Cache(Cache, 0, iface, Adresse_trouvee);
    pragma assert(Adresse_trouvee);
    Put_Line("Attendu après recherche : aucun changement");
    Put_Line("Obtenu :");
    Afficher_cache(Cache,To_Unbounded_String("FIFO"), 100); 
    New_Line;
    Put_Line("Politique FIFO : OK!!"); 
    New_Line;



    Put_Line("||||| Test LFU (taille : 3) |||||"); 
    New_Line;

    Initialiser_Cache(Cache, 3, To_Unbounded_String("LFU"));
    Ajouter_Route_Cache(Cache, 0, To_Unbounded_String("eth0"),0,To_Unbounded_String("LFU"), 0);
    Ajouter_Route_Cache(Cache, 1, To_Unbounded_String("eth1"),0,To_Unbounded_String("LFU") ,0);
    Ajouter_Route_Cache(Cache, 2, To_Unbounded_String("eth2"),0,To_Unbounded_String("LFU") ,0);



    Put_Line("Cache :");
    Afficher_cache(Cache,To_Unbounded_String("LFU"), 100); 
    New_Line;

    Chercher_Cache(Cache, 0,Iface, Adresse_trouvee);
    Chercher_Cache(Cache, 0, Iface, Adresse_trouvee);
    Chercher_Cache(Cache, 2,Iface, Adresse_trouvee);

    Put_Line("Attendu après deux recherches de 0.0.0.0, une recherche de 0.0.0.2 :");
    Put_Line("cache : (ligne 100)  - fréquence d'appels");
    Put_Line("0.0.0.0  eth0                 2");
    Put_Line("0.0.0.1  eth1                 0");
    Put_Line("0.0.0.2  eth2                 1");
    Put_Line("Obtenu :");
    Afficher_cache(Cache,To_Unbounded_String("LFU"), 100); 
    New_Line;


    Put_Line("Politique LFU : OK!!"); 
    New_Line;


end test_Cache_LL;