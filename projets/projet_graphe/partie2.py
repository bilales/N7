import pandas as pd
import numpy as np
import networkx as nx
import matplotlib.pyplot as plt
import fonctions_projet as f


g_avg = pd.read_csv('topology_avg.csv')
g_high = pd.read_csv('topology_high.csv')
g_low = pd.read_csv('topology_low.csv')



## Partie 2 : Graphe Non Valué

# Distribution degré et coefficient de clustering

def DegreeMoyen_et_DistributionDegree(ax, df, limite_max, title, IsPoids):
    # Utiliser la fonction create_graph_from_df pour créer le graphe
    G = f.create_graph_from_df(df, limite_max, IsPoids)
    # Obtenir les degrés des nœuds
    degrees = [G.degree(n) for n in G.nodes()]

    # Calculer le degré moyen
    mean_degree = np.mean(degrees)

    # Pour des valeurs entières de degrés
    max_degree = max(degrees)
    bins = [i - 0.5 for i in range(max_degree + 2)]


    # Tracer l'histogramme des degrés sur l'axe spécifié
    ax.hist(degrees, bins=bins, alpha=0.7, color='green', rwidth=0.8) 
    ax.set_title(title + "- Portée : " + str(limite_max/1000) + "km" + ", Degré moyen =" + str(mean_degree), fontsize=10)
    ax.set_xlabel('Degré')
    ax.set_ylabel('Nombre de nœuds')

def DegreeMoyen_et_DistributionDegree_Clustering(ax, df, limite_max, title, IsPoids):
    # Utiliser la fonction create_graph_from_df pour créer le graphe
    G = f.create_graph_from_df(df, limite_max, IsPoids)

    # Calculer le coefficient de clustering pour chaque nœud
    clustering_coeffs = nx.clustering(G)

    # Obtenir la liste des coefficients de clustering
    clustering_values = list(clustering_coeffs.values())

    # Calculer la moyenne des coefficients de clustering
    mean_clustering = round(np.mean(clustering_values), 3)  # Round to three decimal places

    # Pour des valeurs continues de coefficients, définir les bins de l'histogramme
    bins = np.linspace(0, 1, 20)  # pour des intervalles de 0.05

    # Tracer l'histogramme des coefficients de clustering sur l'axe spécifié
    ax.hist(clustering_values, bins=bins, alpha=0.7, color='blue', rwidth=0.8)
    ax.set_title(title + "- Portée : " + str(limite_max/1000) + "km, Coef moyen clustering = " + str(mean_clustering), fontsize=10)
    ax.set_xlabel('Coefficient de clustering')
    ax.set_ylabel('Nombre de nœuds')

def histgramme_degree():
    fig, axs = plt.subplots(3, 3, figsize=(12, 12))
    limite_maxs = [20000, 40000, 60000]
    titles = ['g_low', 'g_avg', 'g_high']
    dfs = [g_low, g_avg, g_high]

    for i, limite_max in enumerate(limite_maxs):
        for j, df in enumerate(dfs):
            DegreeMoyen_et_DistributionDegree(axs[i, j], df, limite_max, titles[j], False)

    plt.tight_layout()
    plt.show()

histgramme_degree()

def histgramme_degree_Clustering():
    fig, axs = plt.subplots(3, 3, figsize=(12, 12))
    limite_maxs = [20000, 40000, 60000]
    titles = ['g_low', 'g_avg', 'g_high']
    dfs = [g_low, g_avg, g_high]

    for i, limite_max in enumerate(limite_maxs):
        for j, df in enumerate(dfs):
            DegreeMoyen_et_DistributionDegree_Clustering(axs[i, j], df, limite_max, titles[j], False)
    plt.tight_layout()
    plt.show()

histgramme_degree_Clustering()



# Calcul des caractéristiques des graphes : Connexité et Cliques

graphes_20 = [f.create_graph_from_df(e, 20000, False) for e in [g_low, g_avg, g_high]]
graphes_40 = [f.create_graph_from_df(e, 40000, False) for e in [g_low, g_avg, g_high]]
graphes_60 = [f.create_graph_from_df(e, 60000, False) for e in [g_low, g_avg, g_high]]

def plot_cliques_all_ranges(graphes_20, graphes_40, graphes_60):
    portees = [20, 40, 60]
    densites = ['low', 'avg', 'high']
    graphes = [graphes_20, graphes_40, graphes_60]  

    # Initialiser la figure avec 9 subplots (3x3)
    fig, axes = plt.subplots(3, 3, figsize=(18, 12))  # grille de 3x3

    # Itérer sur chaque graphe pour chaque portée et densité
    for i, portee_graphes in enumerate(graphes):
        for j, graphe in enumerate(portee_graphes):


            info_cliques, _ = f.info_graphes_clique_connexite([graphe])
            # Sélectionner le subplot actuel
            ax = axes[i, j]  # i est l'index de la portée, j est l'index de la densité

            # Tracer l'histogramme pour le graphe actuel
            ax.hist(info_cliques, bins=range(1, max(info_cliques)+2), edgecolor='black', align='left', rwidth=0.8)
            ax.set_title(f'Densité {densites[j]} - Portée {portees[i]}km')
            ax.set_xlabel('Ordre de la Clique')
            ax.set_ylabel('Nombre de Cliques')

    # Ajuster l'espacement et afficher la figure

    plt.tight_layout()
    plt.show()


plot_cliques_all_ranges(graphes_20, graphes_40, graphes_60)


def plot_connexite_all_ranges(graphes_20, graphes_40, graphes_60):
    portees = [20, 40, 60]
    densites = ['low', 'avg', 'high']
    graphes = [graphes_20, graphes_40, graphes_60]  

    # Initialiser la figure avec 9 subplots (3x3)
    fig, axes = plt.subplots(3, 3, figsize=(18, 12))  # grille de 3x3

    # Itérer sur chaque graphe pour chaque portée et densité
    for i, portee_graphes in enumerate(graphes):
        for j, graphe in enumerate(portee_graphes):


            _, info_composante = f.info_graphes_clique_connexite([graphe])

            # Sélectionner le subplot actuel
            ax = axes[i, j]  # i est l'index de la portée, j est l'index de la densité

            # Tracer l'histogramme pour le graphe actuel
            ax.hist(info_composante, bins=range(1, max(info_composante)+2), edgecolor='black', align='left', rwidth=0.8)
            ax.set_title(f'Densité {densites[j]} - Portée {portees[i]}km')
            ax.set_xlabel('Ordre de la Clique')
            ax.set_ylabel('Nombre de Cliques')

    # Ajuster l'espacement et afficher la figure)
    plt.tight_layout()
    plt.show()


plot_connexite_all_ranges(graphes_20, graphes_40, graphes_60)




# Calcul des chemins les plus courts pour un graphe Non Valué

# Noms pour les types de graphes
noms_graphes = ['g_low', 'g_avg', 'g_high']

subplot_index = 1
for graphes, portee in [(graphes_20, "20km"), (graphes_40, "40km"), (graphes_60, "60km")]:
    for i, G in enumerate(graphes):
        # Calculer la distribution des longueurs des chemins les plus courts
        distribution = f.calculer_distribution_chemins_courts(G, False)
        # Créer un titre qui inclut le type de graphe et la portée
        titre = f"{noms_graphes[i]} : {portee} / nb chemins distincts : {f.nombre_chemins_distincts(G)}"
        plt.subplot(3, 3, subplot_index)
        # Tracer la distribution
        f.plot_distribution_chemins_courts(distribution, titre, 'en m', False)
        #f.nombre_chemins_distincts(G, titre)
        subplot_index += 1

plt.tight_layout()
plt.show()



