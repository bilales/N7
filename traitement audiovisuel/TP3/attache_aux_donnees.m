function AD = attache_aux_donnees(I,moyennes, variances)

[n,p]=size(I);
dim = [n,p,4];
AD= zeros(dim);

for i=1:4
    AD(:,:,i) =  0.5*(log(variances(i))+((I-moyennes(i)).^2)/(variances(i)));
end

