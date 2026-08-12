using FewBodyDB
using Test

@testset "FewBodyDB.jl" begin
    @testset "lookup" begin
        entry = db(:Bubin2005Jan, Symbol("HD⁺"), :energy, (J = 0, v = 0))

        @test entry isa DatabaseEntry
        @test entry.reference === :Bubin2005Jan
        @test entry.system === Symbol("HD⁺")
        @test entry.observable === :energy
        @test entry.state == (J = 0, v = 0)
        @test entry.value === -0.5978979685

        @test db("Bubin2005Jan/HD⁺/energy/(J = 0, v = 0)").value === entry.value
        @test db(:Karr2006Apr, Symbol("HD⁺"), :energy, (J = 0, v = 0)).value ===
              -0.59789796860903
        @test db(:Suzuki2003Jul, Symbol("Ps⁻"), :energy, "¹Sᵉ").value ===
              -0.2620050702328
        @test db(:Suzuki2003Jul, Symbol("ttμ"), :energy, "¹Fᵒ").value === -101.43

        keys = dbkeys()
        @test keys == sort(keys)
        @test "Suzuki2003Jul/∞Li/energy/¹Sᵉ" in keys
        @test_throws ArgumentError db(:unknown)
    end

    @testset "bibliography" begin
        @test startswith(bib(:Bubin2005Jan), "@article{Bubin2005Jan")
        @test bib(db(:Bubin2005Jan, Symbol("HD⁺"), :energy, (J = 0, v = 0))) ==
              bib("Bubin2005Jan")
        @test_throws ArgumentError bib(:unknown)
    end

    @testset "registration" begin
        state = [1, 2]
        registered = put!(:Bubin2005Jan, :H, :test_observable, state, 1 // 2)
        key = "Bubin2005Jan/H/test_observable/[1, 2]"

        @test registered isa DatabaseEntry{Vector{Int},Rational{Int}}
        @test db(key).value === 1 // 2
        @test_throws ArgumentError put!(
            :Bubin2005Jan,
            :H,
            :test_observable,
            [1, 2],
            1 // 2,
        )
        @test_throws ArgumentError put!(:UnknownReference, :H, :energy, :ground, -0.5)

        # Registration and lookup both isolate mutable state from the registry.
        state[1] = 9
        @test db(key).state == [1, 2]
        result = db(key)
        result.state[1] = 8
        @test db(key).state == [1, 2]
    end

    @testset "legacy macro wrappers" begin
        @test (@get Bubin2005Jan, HD⁺, energy, (J = 0, v = 1)) === -0.5891818291
        @test (@get "Suzuki2003Jul/∞H⁻/energy/¹Sᵉ") === -0.527751016523
        @test startswith(@bib(Bubin2005Jan), "@article{Bubin2005Jan")
    end
end
