using LinearAlgebra
"""
Approximation de la solution du problème 

    min qₖ(s) = s'gₖ + 1/2 s' Hₖ s, sous la contrainte ‖s‖ ≤ Δₖ

# Syntaxe

    s = gct(g, H, Δ; kwargs...)

# Entrées

    - g : (Vector{<:Real}) le vecteur gₖ
    - H : (Matrix{<:Real}) la matrice Hₖ
    - Δ : (Real) le scalaire Δₖ
    - kwargs  : les options sous formes d'arguments "keywords", c'est-à-dire des arguments nommés
        • max_iter : le nombre maximal d'iterations (optionnel, par défaut 100)
        • tol_abs  : la tolérence absolue (optionnel, par défaut 1e-10)
        • tol_rel  : la tolérence relative (optionnel, par défaut 1e-8)

# Sorties

    - s : (Vector{<:Real}) une approximation de la solution du problème

# Exemple d'appel

    g = [0; 0]
    H = [7 0 ; 0 2]
    Δ = 1
    s = gct(g, H, Δ)

"""
function gct(g::Vector{<:Real}, H::Matrix{<:Real}, Δ::Real; 
    max_iter::Integer = 100, 
    tol_abs::Real = 1e-10, 
    tol_rel::Real = 1e-8)

    s= zeros(length(g))
    q(s)= g'*s + (1/2)*s'*H*s
    j= 0
    gj= g
    sj= zeros(length(g))
    pj= -g

    while ((j<= max_iter) && (norm(gj) > max(norm(g)*tol_rel, tol_abs)))
        kj= pj'*H*pj
        if (kj<= 0)
            a= norm(pj)^2
            b= 2*sj'*pj
            c= norm(sj)^2 - Δ^2
            discr= b^2 - 4*a*c
            x1= (-b + sqrt(discr))/(2*a)
            x2= (-b - sqrt(discr))/(2*a)
            if (q(x1*pj + sj) < q(x2*pj + sj))
                sigmaj= x1
            else 
                sigmaj= x2
            end
            s= sj+sigmaj*pj
            break
        end
        αj = (gj'*gj)/kj
        if (norm(sj+αj*pj)>=Δ)
            a=norm(pj)^2
            b= 2*sj'*pj
            c= norm(sj)^2-Δ^2
            discr= b^2 - 4*a*c
            x1=(-b+sqrt(discr))/(2*a)
            x2=(-b-sqrt(discr))/(2*a)
            if (x1>0)
                sigmaj=x1
            else
                sigmaj=x2
            end
            s=sj+sigmaj*pj
            break
        end
        sj= sj + αj*pj
        gj_1 = gj
        gj = gj + αj*H*pj
        βj = norm(gj)^2/norm(gj_1)^2
        pj = -gj + βj*pj
        j = j + 1
        s=sj
    end

    
   return s
end
