function probas = probabilites_EM(D_app, parametres_estim, proportion_1, proportion_2, sigma)
    % Initialisation
    sigma_carre = sigma^2;
    n = size(D_app, 2); % Total number of points

    % Calcul des distances au carré à chaque ellipse pour chaque point
    r_1_carre = calcul_r(D_app, parametres_estim(1,:)).^2;
    r_2_carre = calcul_r(D_app, parametres_estim(2,:)).^2;

    % Calcul des probabilités d'appartenance à chaque ellipse
    denom = (proportion_1 / 2*sigma_carre) * exp(-r_1_carre / (2 * sigma_carre)) + ...
            (proportion_2 / 2*sigma_carre) * exp(-r_2_carre / (2 * sigma_carre));
    prob_1 = (proportion_1 / 2*sigma_carre) * exp(-r_1_carre / (2 * sigma_carre)) ./ denom;
    prob_2 = (proportion_2 / 2*sigma_carre) * exp(-r_2_carre / (2 * sigma_carre)) ./ denom;

    % Assemblage des probabilités normalisées dans une matrice de sortie
    probas = [prob_1; prob_2]; % Correct size should be [2 x 2*n_app]
end
