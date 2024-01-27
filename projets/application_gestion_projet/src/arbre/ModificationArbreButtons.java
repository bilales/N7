package Arbre;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;

public class ModificationArbreButtons extends JPanel{
	

	private JButton ajouterSousTache;
	private JButton supprimerSousTache;
	private JButton modifierSousTache;
	private JButton AfficherSousTache;
	
	
	public ModificationArbreButtons() {
		super();
		modifierSousTache = new JButton("Modifier");
		supprimerSousTache = new JButton("Supprimer");
		ajouterSousTache = new JButton("Ajouter");
		AfficherSousTache = new JButton("Afficher");
		
	    
	    setLayout(new BorderLayout());

	    JPanel buttonPanel = new JPanel(new FlowLayout());
	    buttonPanel.add(ajouterSousTache);
	    buttonPanel.add(supprimerSousTache);
	    buttonPanel.add(modifierSousTache);
	    buttonPanel.add(AfficherSousTache);
	    
	    add(buttonPanel, BorderLayout.SOUTH);
    
	}
	
	public JButton getAjouterButton() {
		return this.ajouterSousTache;
	}
	public JButton getSupprimerButton() {
		return this.supprimerSousTache;
	}
	public JButton getModifierButton() {
		return this.modifierSousTache;
	}
	
	public JButton getAfficherButton() {
		return this.AfficherSousTache;
	}

	public static void main(String[] args) {
	    // Création du panneau contenant les boutons
	    ModificationArbreButtons buttonPanel = new ModificationArbreButtons();

	    // Création du JFrame
	    JFrame frame = new JFrame("Ma fenêtre");
	    frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

	    // Ajout du panneau contenant les boutons à l'intérieur du JFrame
	    frame.getContentPane().add(buttonPanel);

	    // Paramètres du JFrame
	    frame.setSize(400, 200);
	    frame.setVisible(true);
	}
	
	
}
