%%  Application de la SVD : compression d'images

clear all
close all

% Lecture de l'image
I = imread('BD_Asterix_0.png');
I = rgb2gray(I);
I = double(I);


[q, p] = size(I);

% Décomposition par SVD
fprintf('Décomposition en valeurs singulières\n')
tic
[U, S, V] = svd(I);
toc

l = min(p,q);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% On choisit de ne considérer que 200 vecteurs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% vecteur pour stocker la différence entre l'image et l'image reconstuite
inter = 1:20:120;
differenceSVD = zeros(size(inter,2), 1);


%{
% images reconstruites en utilisant de 1 à 200 vecteurs (avec un pas de 40)
ti = 0;
td = 0;
for k = inter

    % Calcul de l'image de rang k
    Im_k = U(:, 1:k)*S(1:k, 1:k)*V(:, 1:k)';

    % Affichage de l'image reconstruite
    ti = ti+1;
    figure(ti)
    colormap('gray')
    imagesc(Im_k)
    
    % Calcul de la différence entre les 2 images
    td = td + 1;
    differenceSVD(td) = sqrt(sum(sum((I-Im_k).^2)));
    pause
end

% Figure des différences entre image réelle et image reconstruite
ti = ti+1;
figure(ti)
hold on 
plot(inter, differenceSVD, 'rx')
ylabel('RMSE')
xlabel('rank k')
pause


%}

% Plugger les différentes méthodes : eig, puissance itérée et les 4 versions de la "subspace iteration method" 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QUELQUES VALEURS PAR DÉFAUT DE PARAMÈTRES, 
% VALEURS QUE VOUS POUVEZ/DEVEZ FAIRE ÉVOLUER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% tolérance
eps = 1e-8;
% nombre d'itérations max pour atteindre la convergence
maxit = 1000;

% taille de l'espace de recherche (m)
search_space = 400;

% pourcentage que l'on se fixe
percentage = 0.995;

% p pour les versions 2 et 3 (attention p déjà utilisé comme taille)
puiss = 1;

%%%%%%%%%%%%%
% À COMPLÉTER
%%%%%%%%%%%%%

%%
% calcul des couples propres
%%
tic
if q>=p    
    %[W, D] = eig(I*I');
    %[W,D] = power_v12( I*I', search_space, percentage, eps, maxit);
    %[W, D] = subspace_iter_v0( I*I', 200, eps, maxit);
    [W, D] = subspace_iter_v1( I*I', search_space, percentage, eps, maxit);
    %[W, D] = subspace_iter_v2( I*I', search_space,percentage,puiss, eps, maxit);
    %[ W, D] = subspace_iter_v3( I*I', search_space, percentage, puiss, eps, maxit);
else 
    %[W, D] = eig(I'*I);
    %[W,D] = power_v12( I'*I, search_space, percentage, eps, maxit);
    %[W, D] = subspace_iter_v0( I'*I, 200, eps, maxit);
    [W, D] = subspace_iter_v1( I'*I, search_space, percentage, eps, maxit);
    %[W, D] = subspace_iter_v2( I'*I, search_space,percentage,puiss, eps, maxit);
    %[ W, D] = subspace_iter_v3( I'*I, search_space, percentage,puiss, eps, maxit);

end
toc
[D, ind ] = sort(diag(D), "descend");

D=diag(D);

W = W(:,ind);
%%
% calcul des valeurs singulières
%%
sigma = sqrt(D);
%%
% calcul de l'autre ensemble de vecteurs
%% 
U = zeros(q,q);
V = zeros(p,p);
if q >= p
    U = W;
    for k =1:size(W ,2)
        V(:,k) =(1/sigma(k,k) )*I'*W(: , k);
    end
else
    V = W;
    for k =1:size(W ,2)
        U(:,k) =(1/sigma(k,k) )*I*W(:,k);
    end
end

%%
% calcul des meilleures approximations de rang faible

for k = inter
    
    % Calcul de l'image de rang k
    Im_k = U(:,1:k)*sigma(1:k,1:k)*V(:,1:k)';
    % Affichage de l'image reconstruite
    figure()
    colormap('gray')        
    imagesc(Im_k)
    % Calcul de la différence entre les 2 images
    differenceSVD(k) = sqrt(sum(sum((I-Im_k).^2)));
end

indice = find(differenceSVD > 0);
differenceSVD= differenceSVD(indice);

figure(10)
hold on 
plot(inter, differenceSVD, 'rx')
ylabel('RMSE')
xlabel('rank k')
