function probas = probabilites(D_app, parametres_estim, sigma)
    % Initialisation
    sigma_carre = sigma^2;

    % Calcul des distances au carré à chaque ellipse pour chaque point
    r_1_carre = calcul_r(D_app, parametres_estim(1,:)).^2;
    r_2_carre = calcul_r(D_app, parametres_estim(2,:)).^2;

    % Calcul des probabilités d'appartenance à chaque ellipse
    prob_1 = (0.5 / sigma) * exp(-r_1_carre / (2 * sigma_carre));
    prob_2 = (0.5 / sigma) * exp(-r_2_carre / (2 * sigma_carre));


    % Assemblage des probabilités normalisées dans une matrice de sortie
    probas = [prob_1; prob_2]; % Matrice de taille [2 x 2*n_app]
end


