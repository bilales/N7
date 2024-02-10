function x = moyenne_3D(I)
    % Conversion en flottants :
    I = single(I);
    
    % Calcul des couleurs normalisées :
    somme_canaux = max(1, sum(I,3));
    r = I(:,:,1) ./ somme_canaux;
    v = I(:,:,2) ./ somme_canaux;
    
    % Calcul des couleurs moyennes :
    r_barre = mean(r(:));
    v_barre = mean(v(:));
    
    % Définir une largeur de bordure pour le calcul du pourtour :
    bordure = 5; % Ajustez selon le besoin
    
    % Calculer séparément pour les différentes sections du pourtour :
    haut = r(1:bordure, :);
    bas = r(end-bordure+1:end, :);
    gauche = r(:, 1:bordure);
    droite = r(:, end-bordure+1:end);
    
    % Moyenne sur les bords verticaux (en excluant les coins doublés) :
    gauche = gauche(bordure+1:end-bordure);
    droite = droite(bordure+1:end-bordure);
    
    % Calcul de la moyenne pour le pourtour :
    r_barre_p = mean([haut(:); bas(:); gauche(:); droite(:)]);
    
    % Calcul de la moyenne pour le complémentaire du pourtour :
    rc = r(bordure+1:end-bordure, bordure+1:end-bordure);
    r_barre_c = mean(rc(:));
    
    % Calcul de la troisième caractéristique :
    diff_rc_rp = r_barre_p - r_barre_c;
    
    % Vecteur de caractéristiques en 3D :
    x = [r_barre, v_barre, diff_rc_rp];
end
