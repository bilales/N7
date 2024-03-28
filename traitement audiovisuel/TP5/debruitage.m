function u_kp1 = debruitage(b,u_k,lambda,Dx,Dy,epsilon)

%%calcul de W qui correspond à la divergence du terme entre parenthèse dans
%%(6)

nb_pixels = length(u_k);
I_N = speye(nb_pixels);
coef_liste= 1./sqrt((Dx*u_k).^2 + (Dy*u_k).^2 + epsilon);
W_k = spdiags(coef_liste,0,nb_pixels, nb_pixels);
A_k = I_N -lambda*(-Dx'*W_k*Dx -Dy'*W_k*Dy);

u_kp1 = A_k\b;
    


end

