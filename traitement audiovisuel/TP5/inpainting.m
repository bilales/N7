function u_kp1 = inpainting(b,u_k,lambda,Dx,Dy,epsilon, W_D)

%%calcul de W qui correspond à la divergence du terme entre parenthèse dans
%%(6)

nb_pixels = length(u_k);
coef_liste= 1./sqrt((Dx*u_k).^2 + (Dy*u_k).^2 + epsilon);
W_k = spdiags(coef_liste,0,nb_pixels, nb_pixels);
A_k = W_D -lambda*(-Dx'*W_k*Dx -Dy'*W_k*Dy);
u_kp1 = A_k\b;
    


end

