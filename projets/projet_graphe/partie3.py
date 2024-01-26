import pandas as pd
import matplotlib.pyplot as plt
import fonctions_projet as f



# Partie 3 : Graphe Valué

g_avg = pd.read_csv('topology_avg.csv')
g_high = pd.read_csv('topology_high.csv')
g_low = pd.read_csv('topology_low.csv')



graphes_60 = [f.create_graph_from_df(e, 60000, True) for e in [g_low, g_avg, g_high]]

plt.figure(figsize=(15, 5))

# Noms pour les types de graphes
noms_graphes = ['g_low', 'g_avg', 'g_high']

subplot_index = 1
for i, G in enumerate(graphes_60):
    # Calculer la distribution des longueurs des chemins les plus courts
    distribution = f.calculer_distribution_chemins_courts(G, True)
    # Créer un titre qui inclut le type de graphe et la portée
    titre = f"{noms_graphes[i]} : 60km"
    plt.subplot(1, 3, subplot_index)
    # Tracer la distribution
    f.plot_distribution_chemins_courts(distribution, titre, 'en km', True)
    subplot_index += 1

plt.tight_layout()
plt.show()

G=f.create_graph_from_df(g_high, 60000, True)

