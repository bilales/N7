package allumettes;

public class JeuReel implements Jeu{
	private int NbAllumettes;
	
	



	@Override
	public void retirer(int nbPrises) throws CoupInvalideException {
		if (nbPrises > PRISE_MAX && nbPrises < NbAllumettes) {
			throw new CoupInvalideException(nbPrises, " (>"+PRISE_MAX+")");
		}
		else if (nbPrises < 1){
			throw new CoupInvalideException(nbPrises, " (< 1)");
		}
		
		else if (nbPrises > NbAllumettes){
			throw new CoupInvalideException(nbPrises, "(> " + NbAllumettes + ")");
		}
		else {
			NbAllumettes = NbAllumettes - nbPrises;
		}
	}




	@Override
	public int getNombreAllumettes() {
		return NbAllumettes;
	}
	
	
	
	public JeuReel(int NbInitial) {
		NbAllumettes = NbInitial;
		
	}




	
	
	


}
