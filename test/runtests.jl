using FewBodyDB
using Test

@testset "FewBodyDB.jl" begin

    # @put
    FewBodyDB.@put Ohno2025Sep, H, energy, (n=1, l=0, m=0), -0.5
    @test "-0.5" == (@get Ohno2025Sep, H, energy, (n=1, l=0, m=0))

    # @bib
    @test "@article{Bubin2005Jan" == (@bib Bubin2005Jan)[1:21]
    @test "@article{Bubin2005Jan" == (@bib "Bubin2005Jan")[1:21]
    # @test "@article{Bubin2005Jan" == (k = "Bubin2005Jan"; @bib k)[1:21]
    @test "@article{Bubin2005Jan" == (k = "Bubin2005Jan"; @bib "$k")[1:21]
    @test "@article{Bubin2005Jan" == FewBodyDB.bib("Bubin2005Jan")[1:21]

    # @get
    @test "-0.5978979685" == @get Bubin2005Jan, HD⁺, energy, (J=0, v=0)
    @test "-0.5978979685" == @get "Bubin2005Jan/HD⁺/energy/(J = 0, v = 0)"
    @test "-0.5978979685" == (k = "Bubin2005Jan/HD⁺/energy/(J = 0, v = 0)"; @get k)
    @test "-0.5978979685" == (v = 0; @get "Bubin2005Jan/HD⁺/energy/(J = 0, v = $v)")

    @test "-0.5891818291" == @get Bubin2005Jan, HD⁺, energy, (J=0, v=1)
    @test "-0.5891818291" == @get "Bubin2005Jan/HD⁺/energy/(J = 0, v = 1)"
    @test "-0.5891818291" == (k = "Bubin2005Jan/HD⁺/energy/(J = 0, v = 1)"; @get k)
    @test "-0.5891818291" == (v = 1; @get "Bubin2005Jan/HD⁺/energy/(J = 0, v = $v)")

    @test "-0.59789796860903" == @get Karr2006Apr, HD⁺, energy, (J=0, v=0)
    @test "-0.59789796860903" == @get "Karr2006Apr/HD⁺/energy/(J = 0, v = 0)"
    @test "-0.59789796860903" == (k = "Karr2006Apr/HD⁺/energy/(J = 0, v = 0)"; @get k)
    @test "-0.59789796860903" == (v = 0; @get "Karr2006Apr/HD⁺/energy/(J = 0, v = $v)")

    @test "-0.2620050702328" == @get Suzuki2003Jul, Ps⁻, energy, "¹Sᵉ"
    @test "-0.2620050702328" == @get "Suzuki2003Jul/Ps⁻/energy/¹Sᵉ"
    @test "-0.2620050702328" == (k = "Suzuki2003Jul/Ps⁻/energy/¹Sᵉ"; @get k)

    @test "-0.527751016523" == @get Suzuki2003Jul, ∞H⁻, energy, "¹Sᵉ"
    @test "-0.527751016523" == @get "Suzuki2003Jul/∞H⁻/energy/¹Sᵉ"

    @test "-0.1252865" == @get Suzuki2003Jul, H⁻, energy, "³Pᵉ"
    @test "-0.1252865" == @get "Suzuki2003Jul/H⁻/energy/³Pᵉ"

    @test "-112.9730179" == @get Suzuki2003Jul, ttμ, energy, "¹Sᵉ"
    @test "-110.2621165" == @get Suzuki2003Jul, ttμ, energy, "¹Pᵒ"
    @test "-111.364511474" == @get Suzuki2003Jul, tdμ, energy, "¹Sᵉ"



end
