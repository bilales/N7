function parametres_MV = max_vraisemblance(D_app,parametres_test)

r=zeros(1,length(parametres_test(:,1)));
    for i=1:length(parametres_test(:,1))
        r_calcule = calcul_r(D_app, parametres_test(i,:));
        r(i) = sum(r_calcule.^2);
    end

[~, indiceMin] = min(r);

parametres_MV = parametres_test(indiceMin, :);

end

