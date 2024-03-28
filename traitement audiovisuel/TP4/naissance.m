function [c,I_moyens, energies] = naissance(N_alea, nbcolonnes, nblignes, I, R, gamma, S, c, q)


I_moyens = zeros(N_alea, 1);
energies = zeros(N_alea, 1);


    
    for i=1:N_alea
        bool = 0;
        while bool ==0 
            c_alea = [nbcolonnes*rand nblignes*rand];
            if isempty(c)
                bool=1;
            else
                bool = cercles_non_recouvert(c, R, c_alea, q);
            end
        end
        c(end+1, :) = c_alea;
        I_moyen = calcul_I_moyen(I, c_alea, R);
        I_moyens(i) = I_moyen;

        energies(i) = 1-2/(1+exp(-gamma*((I_moyen/S)-1)));

    end


end

