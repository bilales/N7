function bool = cercles_non_recouvert(cercles, R, c, indice)
    %premier cercle, on ne compare pas
    if indice == 1
        bool =1;

    else 
        i=1;
        bool=1;
        while i<indice
            if sum((cercles(i, :)-c).^2)<2*R^2
                bool = 0;
                break
            end

            i=i+1;
           
        end
    end
end
