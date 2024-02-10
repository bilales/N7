function X = moindres_carres(D_app)
%on aura besoin de la pseudo inverse voir notes
%on peut aussi utiliser \ qui selon la forme de A va changer la façon de
%trouver la solution

D_app(:, 1)

A=zeros(length(D_app(1, :)), 6);

A(:, 1) = D_app(1,:).^2;
A(:,2) = D_app(1,:).*D_app(2, :);
A(:,3) = D_app(2,:).^2;
A(:,4) = D_app(1,:);
A(:,5) = D_app(2, :);
A(:,6) = ones(length(D_app(1, :)),1);
A(end+1,1) =1;
A(end,3) =1;



B= vertcat(zeros(length(D_app(1, :)), 1),1 );


X = A\B;



end

