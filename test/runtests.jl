using FewBodyDB
using Test

@testset "FewBodyDB.jl" begin

    # @put
    FewBodyDB.@put Ohno2025Sep, H, energy, (n = 1, l = 0, m = 0), -0.5
    @test "-0.5" == (@get Ohno2025Sep, H, energy, (n = 1, l = 0, m = 0))

    # @bib
    @test "@article{Bubin2005Jan" == (@bib Bubin2005Jan)[1:21]
    @test "@article{Bubin2005Jan" == (@bib "Bubin2005Jan")[1:21]
    # @test "@article{Bubin2005Jan" == (k = "Bubin2005Jan"; @bib k)[1:21]
    @test "@article{Bubin2005Jan" == (k = "Bubin2005Jan"; @bib "$k")[1:21]
    @test "@article{Bubin2005Jan" == FewBodyDB.bib("Bubin2005Jan")[1:21]

    # @get
    @test "-0.5978979685" == @get Bubin2005Jan, HD⁺, energy, (J = 0, v = 0)
    @test "-0.5978979685" == @get "Bubin2005Jan/HD⁺/energy/(J = 0, v = 0)"
    @test "-0.5978979685" == (k = "Bubin2005Jan/HD⁺/energy/(J = 0, v = 0)"; @get k)
    @test "-0.5978979685" == (v = 0; @get "Bubin2005Jan/HD⁺/energy/(J = 0, v = $v)")

    @test "-0.5891818291" == @get Bubin2005Jan, HD⁺, energy, (J = 0, v = 1)
    @test "-0.5891818291" == @get "Bubin2005Jan/HD⁺/energy/(J = 0, v = 1)"
    @test "-0.5891818291" == (k = "Bubin2005Jan/HD⁺/energy/(J = 0, v = 1)"; @get k)
    @test "-0.5891818291" == (v = 1; @get "Bubin2005Jan/HD⁺/energy/(J = 0, v = $v)")

    @test "-0.59789796860903" == @get Karr2006Apr, HD⁺, energy, (J = 0, v = 0)
    @test "-0.59789796860903" == @get "Karr2006Apr/HD⁺/energy/(J = 0, v = 0)"
    @test "-0.59789796860903" == (k = "Karr2006Apr/HD⁺/energy/(J = 0, v = 0)"; @get k)
    @test "-0.59789796860903" == (v = 0; @get "Karr2006Apr/HD⁺/energy/(J = 0, v = $v)")

     # Suzuki2003Jul entries (updated)
    @test "-0.2620050702328" == @get Suzuki2003Jul, Ps⁻, energy, "¹Sᵉ"
    @test "-0.2620050702328" == @get "Suzuki2003Jul/Ps⁻/energy/¹Sᵉ"
    @test "-0.2620050702328" == (k = "Suzuki2003Jul/Ps⁻/energy/¹Sᵉ"; @get k)

    @test "-0.527751016523" == @get Suzuki2003Jul, ∞H⁻, energy, "¹Sᵉ"
    @test "-0.527751016523" == @get "Suzuki2003Jul/∞H⁻/energy/¹Sᵉ"

    @test "-0.1252865" == @get Suzuki2003Jul, H⁻, energy, "³Pᵉ"
    @test "-0.1252865" == @get "Suzuki2003Jul/H⁻/energy/³Pᵉ"

    @test "-112.9730179" == @get Suzuki2003Jul, ttμ, energy, "¹Sᵉ"
    @test "-110.2621165" == @get Suzuki2003Jul, ttμ, energy, "¹Pᵒ"
    @test "-105.98293" == @get Suzuki2003Jul, ttμ, energy, "¹Dᵉ"
    @test "-101.43" == @get Suzuki2003Jul, ttμ, energy, "¹Fᵒ"

    @test "-111.364511474" == @get Suzuki2003Jul, tdμ, energy, "¹Sᵉ"
    @test "-108.179385" == @get Suzuki2003Jul, tdμ, energy, "¹Pᵒ"
    @test "-103.408481" == @get Suzuki2003Jul, tdμ, energy, "¹Dᵉ"

    @test "-2.903724376984" == @get Suzuki2003Jul, ∞He, energy, "¹Sᵉ"
    @test "-2.903724372437" == @get Suzuki2003Jul, He, energy, "¹Sᵉ"
    @test "-2.175293782367" == @get Suzuki2003Jul, He, energy, "³Sᵉ"
    @test "-2.123843086498" == @get Suzuki2003Jul, He, energy, "³Pᵒ"
    @test "-2.055620732852" == @get Suzuki2003Jul, He, energy, "¹Dᵉ"
    @test "-2.055338993337" == @get Suzuki2003Jul, ∞He, energy, "³Dᵉ"
    @test "-2.031255144382" == @get Suzuki2003Jul, He, energy, "¹Fᵒ"
    @test "-2.031255168403" == @get Suzuki2003Jul, He, energy, "³Fᵒ"
    @test "-2.020000710898" == @get Suzuki2003Jul, He, energy, "¹Gᵉ"
    @test "-2.020000710925" == @get Suzuki2003Jul, He, energy, "³Gᵉ"

    @test "-3.50763486" == @get Suzuki2003Jul, p̄He⁺, energy, "L=31"
    @test "-7.279913" == @get Suzuki2003Jul, ∞Li, energy, "¹Sᵉ"

end
