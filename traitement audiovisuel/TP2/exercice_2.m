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
% Regroupement en 3 clusters par l'algorithme des k-moyennes
%--------------------------------------------------------------------------

% Partition des donnees :
X = [X_pensees ; X_oeillets ; X_chrysanthemes];




evaCH = evalclusters(X, 'kmeans', 'CalinskiHarabasz', 'KList', 2:7);
evaDB = evalclusters(X, 'kmeans', 'DaviesBouldin', 'KList', 2:7);


fprintf('Nombre optimal de clusters selon Calinski-Harabasz: %d\n', evaCH.OptimalK);
fprintf('Nombre optimal de clusters selon Davies-Bouldin: %d\n', evaDB.OptimalK);

