clear;
close all;

taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);





% Parametres :
N = 50;					% Nombre de disques de la configuration configuration initiale
R = 7;					% Rayon des disques
nb_points_affichage_disque = 30;
increment_angulaire = 2*pi/nb_points_affichage_disque;
theta = 0:increment_angulaire:2*pi;
rose = [253 108 158]/255;
q_max = 200;
nb_affichages = 1000;
pas_entre_affichages = floor(q_max/nb_affichages);
temps_pause = 0.0001;

beta = 1;
S = 140;
gamma = 5;
T0 = 0.1;
lambda0 = 100;
alpha = 0.99;
lambda = lambda0;
T= T0;


% Lecture et affichage de l'image :
I = imread('colonie.png');
I = rgb2ycbcr(I);
I = double(I(:,:,1));
[nb_lignes,nb_colonnes] = size(I);
figure('Name',['Detection de ' num2str(N) ' flamants roses'],'Position',[0,0,L,0.58*H]);



liste_q = 0;
%I_moyen_config = mean(I_moyen);
%liste_I_moyen_config = I_moyen_config;

% Affichage de la configuration initiale :

c=[0, 0];
I_moyen = [];
energie=[];
% Recherche de la configuration optimale :
for q = 1:q_max
	i = rem(q,N)+1;					% On parcourt les N disques en boucle


	% Tirage aleatoire des N_alea nouveau disque et calcul du niveau de gris moyen :
    N_alea = poissrnd(lambda);
    [c, I_moyens, energies] = naissance(N_alea, nb_colonnes, nb_lignes, I, R, gamma, S, c, i);

    % mise à jour des listes
    I_moyen = [I_moyen; I_moyens];
    energie = [energie; energies];

    %tri des listes
    [energie, idx] = sort(energie, 'descend');
    
    c = c(idx, :);
    I_moyen = I_moyen(idx);
    





	% on supprime les les mauvais disques recuit simulé, mises a jour :

    [idx,energie] = mort(energie, R, beta, c, T, lambda);

    

    if isempty(idx)
        break;
    else 
        T = alpha*T;
        lambda = alpha*lambda;

        c(idx) = [];
        I_moyen(idx) = [];
    
    
	    hold off;
	    subplot(1,2,1);
	    imagesc(I);
	    axis image;
	    axis off;
	    colormap gray;
	    hold on;
	    for j = 1:length(c)
		    x_affich = c(j,1)+R*cos(theta);
		    y_affich = c(j,2)+R*sin(theta);
		    indices = find(x_affich>0 & x_affich<nb_colonnes & y_affich>0 & y_affich<nb_lignes);
		    plot(x_affich(indices),y_affich(indices),'Color',rose,'LineWidth',3);
	    end
	    pause(temps_pause);
	    end
    
	    % Courbe d'evolution du niveau de gris moyen :
	    if rem(q,pas_entre_affichages)==0
		    liste_q = [liste_q q];
		    I_moyen_config = mean(I_moyen);
		    liste_I_moyen_config = [liste_I_moyen_config I_moyen_config];
		    subplot(1,2,2);
		    plot(liste_q,liste_I_moyen_config,'.-','Color',rose,'LineWidth',3);
		    axis([0 q_max 0 255]);
		    set(gca,'FontSize',20);
		    xlabel('Nombre d''iterations','FontSize',20);
		    ylabel('Niveau de gris moyen','FontSize',20);
        end





end




