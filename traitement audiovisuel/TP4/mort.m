function [idx,energie] = mort(energie, R, beta, c, T, lambda)

n = length(energie);

idx = [];

for i=1:n
    somme = 0;
    for j=1:n
        if j~= i
        if sum((c(j, :)-c(i, :)).^2) < 2*R^2
            somme = somme + 1;
        end
        end
    if i == 1
        somme = sum((c(2, :)-c(1, :)).^2) < 2*R^2;
    elseif i == n
        somme = sum((c(n, :)-c(n-1, :)).^2) < 2*R^2;
    else
        somme = 

    end
    proba_i = lambda/(lambda +exp(((-energie(i) - beta*(somme))/T)));

    if rand < proba_i
        idx = [idx; i];

    end
    
end

energie(idx)= [];


end

