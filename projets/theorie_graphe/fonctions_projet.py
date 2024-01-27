import pandas as pd
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
import networkx as nx
import numpy as np
import networkx as nx
import matplotlib.pyplot as plt


# Définir les arêtes, c'est-à-dire les liens entre les drones
def add_edges(ax, df, distance):
    for i in range(len(df)):
        for j in range(i+1, len(df)):
            dist = np.sqrt((df['x'][i] -df['x'][j])**2 + (df['y'][i] - df['y'][j])**2 + (df['z'][i] -df['z'][j])**2)
            if dist <= distance:
                ax.plot([df['x'][i],df['x'][j]], [df['y'][i], df['y'][j]], [df['z'][i], df['z'][j]], color='red', linewidth=0.25) 


# Définir la représentation graphique
def representation_graphique(ax, title, df):
    ax.scatter(df['x'], df['y'], df['z'])
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    ax.set_title(title)


#un dataframe n'a pas d'obtjets sommets et arretes en tant que telles
# ainsi on le transforme en graphe avec networkx qui lui propose ces objets
    # df : dataframe
    # limite_max : distance maximale entre deux satellites pour qu'ils soient connectés
    # IsPoids : True si on veut que un poids pour les arrêtes, False sinon
def create_graph_from_df(df, limite_max, IsPoids):

    G = nx.Graph()
    # Ajouter des nœuds
    for i, row in df.iterrows():
        G.add_node(i, pos=(row['x'], row['y'], row['z']))
    # Ajouter des arêtes
    for i in range(len(df)):
        for j in range(i+1, len(df)):
            pos_i = df.loc[i, ['x', 'y', 'z']]
            pos_j = df.loc[j, ['x', 'y', 'z']]
            dist = np.linalg.norm(pos_i - pos_j)
            if dist <= limite_max:
                if IsPoids:
                    G.add_edge(i, j, weight=(dist/1000)**2)
                else:
                    G.add_edge(i, j)
    return G

#Partie 2:


# Calculer la distribution des longueurs des chemins les plus courts
    # G : graphe
    # IsPoids : True si on veut que un poids pour les arrêtes, False sinon
def calculer_distribution_chemins_courts(G, IsPoids):
    if IsPoids:
        # Avec paramètre weight, la fonction renvoie la longueur des chemins les plus courts en somme des poids
        longueurs = dict(nx.shortest_path_length(G, weight='weight'))
    else:
        # Sans paramètre weight, la fonction renvoie la longueur des chemins les plus courts en noomnre d'arêtes
        longueurs = dict(nx.shortest_path_length(G))

    # On crée un dictionnaire pour stocker la distribution des longueurs des chemins les plus courts
    distribution = {}
    for source in longueurs:
        for target in longueurs[source]:
            if source < target:  # Assure que chaque paire est traitée une seule fois
                    length = longueurs[source][target]
                    # on augmente le nombre de fois qu'on a cette longueur, length est la clé du dictionnaire
                    distribution[length] = distribution.get(length, 0) + 1
    return distribution


# Fonction pour créer et afficher un ensemble de graphes
     # graphes : liste des graphes
def info_graphes_clique_connexite(graphes):
    info_cliques = []
    info_composantes = []

    for G in graphes:
        tailles_cliques = [len(clique) for clique in nx.find_cliques(G)]
        tailles_composantes = [len(composant) for composant in nx.connected_components(G)]
        
        info_cliques.extend(tailles_cliques)
        info_composantes.extend(tailles_composantes)
        #print("Nombre de cliques :", len(tailles_cliques))
    
    return info_cliques, info_composantes




# Fonction pour créer et afficher un ensemble de graphes
    # distribution : distribution des longueurs des chemins les plus courts
    # title : titre du graphe
def plot_distribution_chemins_courts(distribution, title, unite, IsPoids):
    # on réupère les items du dictionnaire, la clé est une la longueur du chemin et la valeur est le nombre de fois qu'on a cette longueur
    items = distribution.items()
    # on trie les items par longueur de chemin
    sorted_items = sorted(items)
    # on sépare les longueurs et les fréquences
    lengths, frequence = zip(*sorted_items)
    # on trace le graphe
    if IsPoids:
        plt.hist(lengths, bins='auto', edgecolor='black')
        plt.xlim(0, 15000)
    else:
        plt.bar(lengths, frequence)
    plt.title(f"{title}")
    plt.xlabel('Longueur du Chemin '+unite)
    plt.ylabel('Fréquence')
    #print("somme longueurs:" + title, np.sum(frequencies))


def nombre_chemins_distincts(G):
    nombre_total_chemins = 0
    for source in G.nodes():
        for target in G.nodes():
            if source < target:  # Évite les doublons et les chemins de nœud à lui-même
                if nx.has_path(G, source, target):  # Vérifie si un chemin existe
                    all_paths = list(nx.all_shortest_paths(G, source, target))
                    nombre_total_chemins += len(all_paths)

    return nombre_total_chemins


