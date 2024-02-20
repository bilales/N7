function k = recuit_simule(k,AD,beta,T)

% k la matrice des voisinages

[n,p, m] = size(AD);

for i=1:n
    for j=1:p
        %on extrait la sous matrice de k, voisinage du pixel au centre 
        %en prenant garde aux bornes
        voisinage_k = k(max(1, i-1):min(n, i+1), max(1, j-1):min(p, j+1));
        %classe du pixel central
        k_ij= k(i,j);
        %calcul energie locale avec la classe du pixel au centre
        Us = 0.5*AD(i,j,k_ij) + beta*(sum(sum(voisinage_k~=k_ij)));

        %calcul nouvealle energie, k' tirée aléatoirement
        k_prime = randi(m);
        while k_prime == k_ij
            k_prime = randi(m);
        end

        Us_prime = 0.5*AD(i,j,k_prime) + beta*(sum(sum(voisinage_k~=k_prime))-1);

        %comparison

        if Us_prime < Us
            k(i,j)= k_prime;
        else
            if rand<exp(-(Us_prime-Us)/T)
                k(i,j)=k_prime;
            end

        end

    end
end

end

