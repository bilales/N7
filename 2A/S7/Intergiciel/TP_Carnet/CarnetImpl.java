import java.rmi.RemoteException;
import java.util.*;

public class CarnetImpl implements Carnet{
	
	private Map<String, RFiche> carnet = new HashMap<>();

	@Override
	public void Ajouter(SFiche sf) throws RemoteException {
		RFiche rf = new RFicheImpl(sf.getNom(), sf.getEmail());
		carnet.put(sf.getNom(), rf);
		System.out.println("personne ajoutée : " + sf.getNom());
		
	}

	@Override
	public RFiche Consulter(String n, boolean forward) throws RemoteException {
		if(carnet.containsKey(n)){
			RFiche rf = carnet.get(n);
			System.out.println("Personne consultée : " + n);
			return rf;
		}
		else {
			System.out.println("Personne inexistante : " + n);
			return null;}
	}
	
	
}