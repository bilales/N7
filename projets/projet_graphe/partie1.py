import pandas as pd
import networkx as nx
import matplotlib.pyplot as plt
import fonctions_projet as f

# Lire les fichiers CSV sous forme de Data Frame
g_avg = pd.read_csv('topology_avg.csv')
g_high = pd.read_csv('topology_high.csv')
g_low = pd.read_csv('topology_low.csv')



## Partie 1 : Représenter graphiquement l’essaim dans les trois configurations de densité 
# et pour les trois niveaux de portée.


# Fonction pour créer et afficher un ensemble de graphes
def plot_graphs(title, limite_max):
    fig = plt.figure(figsize=(15, 5))
    fig.suptitle(title) 

    # Graphe pour g_low
    ax1 = fig.add_subplot(131, projection='3d')
    f.representation_graphique(ax1, "topology_low",g_low)
    f.add_edges(ax1, g_low, limite_max)

    # Graphe pour g_avg
    ax2 = fig.add_subplot(132, projection='3d')
    f.representation_graphique(ax2, "topology_avg",g_avg)
    f.add_edges(ax2, g_avg, limite_max)

    # Graphe pour g_high
    ax3 = fig.add_subplot(133, projection='3d')
    f.representation_graphique(ax3, "topology_high",g_high)
    f.add_edges(ax3, g_high, limite_max)


    plt.show()

# Appeler la fonction pour chaque portée
plot_graphs('Représentation graphique de l’essaim avec portée de 20km', 20000)
plot_graphs('Représentation graphique de l’essaim avec portée de 40km', 40000)
plot_graphs('Représentation graphique de l’essaim avec portée de 60km', 60000)