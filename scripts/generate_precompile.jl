using Pkg

# blacklist
# ---------

# update when an assertion fails
blacklist = [
    # "precompile(Tuple{typeof(Atom.processval!),Any,String,Array{Any,1}})"
    # "precompile(Tuple{typeof(Atom.processval!),Function,String,Array{Any,1}})"
    # "precompile(Tuple{typeof(Atom.render′),Juno.Inline,Type})"
    # "precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Any})"
    # "precompile(Tuple{typeof(Atom.wstype),Module,Symbol,Any})"
    # "precompile(Tuple{typeof(Base.Broadcast.broadcasted),Function,Array{Atom.GotoItem,1},Function})"
    # "precompile(Tuple{typeof(Base.allocatedinline),Type{Atom.GotoItem}})"
    # "precompile(Tuple{typeof(Media.render),Juno.Inline,Type})"
    # "precompile(Tuple{typeof(getfield′),Any,String,Atom.Undefined})"
    # "precompile(Tuple{typeof(getfield′),Any,String})"
    # "precompile(Tuple{typeof(getfield′),Any,Symbol,Atom.Undefined})"
    # "precompile(Tuple{typeof(getfield′),Any,Symbol})"
]

# add dependencies
# ----------------

package_dir = normpath(joinpath(@__DIR__, ".."))
atomjl_file = joinpath(package_dir, "src", "Atom.jl")
project_file = joinpath(package_dir, "Project.toml")
test_file = joinpath(package_dir, "test", "runtests.jl")
precompile_file = joinpath(package_dir, "src", "precompile.jl")

lines = readlines(atomjl_file; keep = true)

toml = Pkg.TOML.parsefile(project_file)
test_deps = get(toml, "extras", nothing)

@info "Adding temporary dependencies ..."
test_deps !== nothing && Pkg.add([PackageSpec(; name = name, uuid = uuid) for (name, uuid) in test_deps])
Pkg.add("SnoopCompile")

# generate and assert
# -------------------

using SnoopCompile

try
    @info "Generating `precompile` statements ..."
    try
        open(atomjl_file, "w") do io
            for line in lines
                if occursin("_precompile_()", line)
                    write(io, "# _precompile_()\n") # comment out
                else
                    write(io, line)
                end
            end
        end
        @debug "Commented out `_precompile_` call in $atomjl_file for `precompile` statement generation"

        inf_timing = @snoopi include(test_file)
        pc = SnoopCompile.parcel(inf_timing; blacklist=["Main"]) # NOTE: don't include functions used in test

        if (stmts = get(pc, :Atom, nothing)) !== nothing
            open(precompile_file, "w") do io
                println(io, "# This file is mostly generated by `scripts/generate_precompile.jl`\n")
                if any(str->occursin("__lookup", str), stmts)
                    println(io, SnoopCompile.lookup_kwbody_str)
                end
                println(io, "function _precompile_()")
                println(io, "    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing")
                for stmt in sort(stmts)
                    if startswith(stmt, "isdefined")
                        println(io, """
                                        try
                                            $(stmt)
                                        catch err
                                            @debug err
                                        end
                                    """) # don't asset on this
                    elseif stmt in blacklist
                        println(io, "    # ", stmt) # comment out blacklist
                    else
                        println(io, """
                                        try
                                            @assert($(stmt))
                                        catch err
                                            @debug err
                                        end
                                    """)
                    end
                end
                println(io, "end")
            end
        end
    catch e
        printstyled(
            "`precompile` statement generation failed with the following error:\n";
            bold = true, color = :lightred
        )
        @error e
    end

    @info "Asserting generated statements ..."
    try
        open(atomjl_file, "w") do io
            for line in lines
                if occursin("# _precompile_()", line)
                    write(io, "_precompile_()\n") # comment in
                else
                    write(io, line)
                end
            end
        end
        @debug "Commented in `_precompile_` call in $atomjl_file for `precompile` statement assertion"

        err_io = IOBuffer()
        run(pipeline(`julia --project=. --color=yes -e 'using Pkg; Pkg.precompile()'`; stderr = err_io))
        err = String(take!(err_io))
        if occursin("ERROR", err)
            printstyled(
                "An invalid `precompile` statement has been generated:\n";
                bold = true, color = :lightred
            )
            @error err
        else
            printstyled(
                "Asserted all the `precompile` statements. You're good to call `_precompile_` for now.\n";
                bold = true, color = :lightgreen
            )
        end
    catch e
        printstyled(
            "`precompile` statement assertion failed with the following error:\n";
            bold = true, color = :lightred
        )
        @error e
    finally
        # let lines = readlines(precompile_file; keep = true)
        #     open(precompile_file, "w") do io
        #         for line in lines
        #             write(io, replace(line, "@assert " => ""))
        #         end
        #     end
        # end
        # @info "Removed `@assert`s in $precompile_file"
    end
catch e
    printstyled(
        "Unexpected error happened:\n";
        bold = true, color = :lightred
    )
    @error e
finally
    open(atomjl_file, "w") do io
        for line in lines
            write(io, line)
        end
    end
    @info "Restored the original state in $atomjl_file"
end

# remove dependencies
# -------------------

@info "Removing temporary dependencies ..."
test_deps === nothing || Pkg.rm([PackageSpec(; name = name, uuid = uuid) for (name, uuid) in test_deps])
Pkg.rm("SnoopCompile")
