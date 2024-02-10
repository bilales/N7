% Lire l'image
I = imread('Donnees/piments.png');

% Obtenir les dimensions de l'image
[hauteur, largeur, ~] = size(I);

% Préparer les données pour le regroupement
% Convertir l'image en un tableau de caractéristiques de taille (nombre_de_pixels x 5)
% où les 5 caractéristiques sont R, V, B, x (numéro de colonne), y (numéro de ligne)
R = double(I(:,:,1));
V = double(I(:,:,2));
B = double(I(:,:,3));
[x, y] = meshgrid(1:largeur, 1:hauteur);
caracteristiques = [R(:) V(:) B(:) x(:) y(:)];

% Appliquer k-means pour segmenter l'image
% Le nombre de clusters (k) est à choisir selon le résultat souhaité
k = 3; % Exemple : 3 pour segmenter en 3 couleurs principales
[idx, ~] = kmeans(caracteristiques, k, 'Distance', 'sqEuclidean', 'MaxIter', 100, 'Replicates', 3);

% Remapper les étiquettes des clusters aux pixels pour visualiser le résultat
idxImage = reshape(idx, hauteur, largeur);

% Créer une figure pour l'affichage
figure;

% Afficher l'image originale
subplot(1, 2, 1); % Diviser la fenêtre en 1 ligne, 2 colonnes, et sélectionner la 1ère cellule
imshow(I);
title('Image Originale');

% Afficher l'image segmentée
subplot(1, 2, 2); % Sélectionner la 2ème cellule pour l'image segmentée
imagesc(idxImage); % Utiliser imagesc pour afficher l'image segmentée
colormap('jet'); % Utiliser une colormap pour différencier les clusters
title('Image Segmentée');
axis image off; % Ajuster les axes pour enlever les chiffres

