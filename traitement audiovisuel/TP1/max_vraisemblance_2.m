function parametres_estim = max_vraisemblance_2(D_app,parametres_test,sigma)

    sigma_carre = sigma^2;

    vraisemblance=zeros(1,length(parametres_test(:,1,1)));
    for i=1:length(parametres_test(:,1,1))
        r_calcule_1_carre = calcul_r(D_app, parametres_test(i,1,:)).^2;
        r_calcule_2_carre = calcul_r(D_app, parametres_test(i,2,:)).^2;
        vraisemblance(i) = sum(log((0.5/sigma)*exp(-r_calcule_1_carre/(2*sigma_carre))+(0.5/sigma)*exp(-r_calcule_2_carre/(2*sigma_carre))));
    end

    [~, indiceMax] = max(vraisemblance);

    parametres_estim = [parametres_test(indiceMax,1,:);parametres_test(indiceMax,2,:)];

    
end

