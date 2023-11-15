import java.io.Serializable;

public class SFicheImpl implements SFiche, Serializable {
    private String nom;
    private String email;

    public SFicheImpl(String nom, String email) {
        this.nom = nom;
        this.email = email;
    }

    @Override
    public String getNom() {
        return nom;
    }

    @Override
    public String getEmail() {
        return email;
    }
}
