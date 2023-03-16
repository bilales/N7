package allumettes;

public class JeuProxy implements Jeu{
	private Jeu jeu;
	
	
	@Override
	public int getNombreAllumettes() {
		return jeu.getNombreAllumettes();
	}

	@Override
	public void retirer(int nbPrises) throws CoupInvalideException {
		throw new OperationInterditeException(nbPrises,"triche");
		
	}
	
	public JeuProxy(Jeu jeux) {
		jeu=jeux;
	}


	
	
	

	
}
