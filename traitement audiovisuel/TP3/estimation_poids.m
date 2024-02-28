function [poids,argument] = estimation_poids(mu_test,sigma_test,liste_nvg,F)

N = length(mu_test);

A = zeros(length(liste_nvg), N);

for i=1:N
    A(:, i) = (1/(sigma_test(i)*sqrt(2*pi)))*exp((-(liste_nvg'-mu_test(i)).^2/(2*sigma_test(i)^2)));
end

poids = A\F';

F_estime  =A*poids;

argument = sum((F - F_estime').^2);

end

