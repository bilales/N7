# Ecrire les tests de l'algorithme du pas de Cauchy
using Test

function tester_cauchy(cauchy::Function)

    tol_test = 1e-3

	@testset "Pas de Cauchy" begin
        grad = [0 ; 0]
        Hess = [7 0 ; 0 2]
        delta = 1
        s = cauchy(grad, Hess, delta)
        @test s ≈ [0.0 ; 0.0] atol = tol_test
    
        # Gradient Non Nul et Hessienne Définie Positive
        grad = [6 ; 2]
        Hess = [7 0 ; 0 2]
        delta = 0.5
        s = cauchy(grad, Hess, delta)
        @test s ≈ -delta * grad / norm(grad) atol = tol_test
    
        # Matrice avec 1 Valeur Propre < 0 et 1 Valeur Propre > 0
        grad = [1 ; 2]
        Hess = [1 0 ; 0 -1]
        delta = 1
        s = cauchy(grad, Hess, delta)
        @test s ≈ -delta * grad / norm(grad) atol = tol_test
    
        # Gradient Non Nul et Hessienne Définie Négative
        grad = [4 ; -3]
        Hess = [-2 0 ; 0 -6]
        delta = 0.5
        s = cauchy(grad, Hess, delta)
        @test s ≈ -delta * grad / norm(grad) atol = tol_test
    
        # Gradient Non Nul et Hessienne Semi-Définie Positive
        grad = [3 ; -4]
        Hess = [5 0 ; 0 0]
        delta = 1
        s = cauchy(grad, Hess, delta)
        @test s ≈ -delta * grad / norm(grad) atol = tol_test
    
    
        # Gradient Fort et Hessienne Définie Positive
        grad = [10 ; -10]
        Hess = [4 0 ; 0 4]
        delta = 2
        s = cauchy(grad, Hess, delta)
        @test s ≈ -delta * grad / norm(grad) atol = tol_test
    
        # Gradient Nul et Hessienne Indéfinie
        grad = [2 ; 0]
        Hess = [4 0 ; 0 -15]
        delta = 2
        s = cauchy(grad, Hess, delta)
        @test s ≈ [-0.5 ; 0.0] atol = tol_test
    end

end