clear;
close all;

load donnees_exercice_1;

%--------------------------------------------------------------------------
% Calcul des couleurs moyennes des images
%--------------------------------------------------------------------------

% Couleurs moyennes des trois especes de fleurs :
X_pensees = single(zeros(nb_pensees,2));
Y = zeros(nb_pensees+nb_oeillets+nb_chrysanthemes,1);
indY = 1;
for i = 1:nb_pensees
	im = eval(['pe' num2str(i)]);
	X_pensees(i,:) = moyenne_2D(im);
	Y(indY) = 1;
	indY = indY+1;
end
X_oeillets = single(zeros(nb_oeillets,2));
for i = 1:nb_oeillets
	im = eval(['oe' num2str(i)]);
	X_oeillets(i,:) = moyenne_2D(im);
	Y(indY) = 2;
	indY = indY+1;
end
X_chrysanthemes = single(zeros(nb_chrysanthemes,2));
for i = 1:nb_chrysanthemes
	im = eval(['ch' num2str(i)]);
	X_chrysanthemes(i,:) = moyenne_2D(im);
	Y(indY) = 3;
	indY = indY+1;
end

%--------------------------------------------------------------------------
% Affichage des donnees suivant les 3 especes de fleurs 
%--------------------------------------------------------------------------

figure('Name','Repartition des images suivant leurs couleurs moyennes',...
       'Position',[0.02*L,0.1*H,0.47*L,0.7*H],...
       'Color',[0.7 0.75 0.85]);
hold on;
plot(X_pensees(:,1),X_pensees(:,2),'bx','MarkerSize',15,'LineWidth',3);
plot(X_oeillets(:,1),X_oeillets(:,2),'ro','MarkerSize',15,'LineWidth',3);
plot(X_chrysanthemes(:,1),X_chrysanthemes(:,2),'c+','MarkerSize',15,'LineWidth',3);
axis xy;
grid on;

title('Couleurs moyennes des images');
xlabel('$\bar{r}$','Interpreter','Latex');
ylabel('$\bar{v}$','Interpreter','Latex');
legend('Pensees','Oeillets','Chrysantemes','Location','Best');
set(gca,'FontSize',20);

%--------------------------------------------------------------------------
% Regroupement en 3 clusters par l'algorithme des k-moyennes
%--------------------------------------------------------------------------

% Partition des donnees :
X = [X_pensees ; X_oeillets ; X_chrysanthemes];

for k=2:7

Y_pred = kmeans(X,k);

% Evaluation numerique de la partition :
score_partition = calcul_score(Y_pred,Y);

% Affichage de la partition :
couleur = [1 0 0 ; 0 1 1 ; 0 0 1 ; 1 0 1 ; 1 1 0 ; 0 1 0 ; 0 0 0];
leg = cell(1,k);
figure('Name','Regroupement des images en 3 clusters',...
       'Position',[0.51*L,0.1*H,0.47*L,0.7*H],'Color',[0.7 0.75 0.85]);
hold on;
for i = 1:k
	indices_i = (Y_pred==i);
	leg{i} = plot(X(indices_i,1),X(indices_i,2),'*',...
                  'MarkerSize',15,'LineWidth',3,'Color',couleur(i,:));
end
axis xy;
grid on;

title(['Score de la partition = ' num2str(score_partition,'%.1f')]);
xlabel('$\bar{r}$','Interpreter','Latex');
ylabel('$\bar{v}$','Interpreter','Latex');
legend([leg{1},leg{2},leg{3}],'Cluster 1','Cluster 2','Cluster 3','Location','Best');
set(gca,'FontSize',20);

end