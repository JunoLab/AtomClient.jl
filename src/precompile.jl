# This file is mostly generated by `scripts/generate_precompile.jl`

const __bodyfunction__ = Dict{Method,Any}()

# Find keyword "body functions" (the function that contains the body
# as written by the developer, called after all missing keyword-arguments
# have been assigned values), in a manner that doesn't depend on
# gensymmed names.
# `mnokw` is the method that gets called when you invoke it without
# supplying any keywords.
function __lookup_kwbody__(mnokw::Method)
    function getsym(arg)
        isa(arg, Symbol) && return arg
        @assert isa(arg, GlobalRef)
        return arg.name
    end

    f = get(__bodyfunction__, mnokw, nothing)
    if f === nothing
        fmod = mnokw.module
        # The lowered code for `mnokw` should look like
        #   %1 = mkw(kwvalues..., #self#, args...)
        #        return %1
        # where `mkw` is the name of the "active" keyword body-function.
        ast = Base.uncompressed_ast(mnokw)
        if isa(ast, Core.CodeInfo) && length(ast.code) >= 2
            callexpr = ast.code[end-1]
            if isa(callexpr, Expr) && callexpr.head == :call
                fsym = callexpr.args[1]
                if isa(fsym, Symbol)
                    f = getfield(fmod, fsym)
                elseif isa(fsym, GlobalRef)
                    if fsym.mod === Core && fsym.name === :_apply
                        f = getfield(mnokw.module, getsym(callexpr.args[2]))
                    elseif fsym.mod === Core && fsym.name === :_apply_iterate
                        f = getfield(mnokw.module, getsym(callexpr.args[3]))
                    else
                        f = getfield(fsym.mod, fsym.name)
                    end
                else
                    f = missing
                end
            else
                f = missing
            end
        else
            f = missing
        end
        __bodyfunction__[mnokw] = f
    end
    return f
end

function _precompile_()
    ccall(:jl_generating_output, Cint, ()) == 1 || return nothing
    try; @assert(Base.precompile(Tuple{Core.kwftype(typeof(Atom.Type)),NamedTuple{(:rl, :ll, :url, :detail), NTuple{4, String}},Type{Atom.CompletionSuggestion},String,String,String,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{Core.kwftype(typeof(Atom._collecttoplevelitems_static)),NamedTuple{(:inmod,), Tuple{Bool}},typeof(Atom._collecttoplevelitems_static),Nothing,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{Core.kwftype(typeof(Atom.modulefiles)),NamedTuple{(:inmod,), Tuple{Bool}},typeof(modulefiles),String,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{Core.kwftype(typeof(Atom.toplevelitems)),NamedTuple{(:mod, :inmod), Tuple{String, Bool}},typeof(toplevelitems),String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{Type{Atom.EvalError},StackOverflowError,Vector{Base.StackTraces.StackFrame}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{Type{Atom.GotoItem},String,Atom.ToplevelCall})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{Type{Atom.GotoItem},String,Atom.ToplevelMacroCall})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{Type{Atom.GotoItem},String,Atom.ToplevelModuleUsage})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{Type{Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1}, Axes, F, Args} where Args<:Tuple where F where Axes},typeof(Atom.completion),Tuple{Base.RefValue{Module}, Vector{FuzzyCompletions.Completion}, Base.RefValue{String}}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{Type{JSON.Writer.CompositeTypeWrapper},Atom.CompletionSuggestion,NTuple{9, Symbol}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{Type{Set},Vector{OutlineItem}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom._collecttoplevelitems_loaded),String,Vector{String}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.allprojects)})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.appendline),String,Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.completion),Module,FuzzyCompletions.DictCompletion,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.completion),Module,FuzzyCompletions.KeywordCompletion,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.completion),Module,FuzzyCompletions.ModuleCompletion,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.completion),Module,FuzzyCompletions.PathCompletion,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.completion),Module,FuzzyCompletions.PropertyCompletion,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.completion),Module,REPL.REPLCompletions.DictCompletion,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.completion),Module,REPL.REPLCompletions.FieldCompletion,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.completion),Module,REPL.REPLCompletions.KeywordCompletion,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.completion),Module,REPL.REPLCompletions.ModuleCompletion,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.completion),Module,REPL.REPLCompletions.PathCompletion,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.completion),Module,REPL.REPLCompletions.PropertyCompletion,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.completiondetail!),Dict{String, Any}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.description),MD})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.displayandrender),Module})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.displayandrender),Symbol})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.docs),String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.eval),String,Int64,String,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.evalall),String,String,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.evalshow),String,Int64,String,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.evalsimple),String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.finddevpackages)})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.fullREPLpath),String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.fullpath),String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.fuzzycompletionadapter),String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.handlemsg),Dict{String, Any},String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.handlemsg),Dict{String, Any}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.isactive),IOBuffer})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.localgotoitem),String,Nothing,Int64,Int64,Int64,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.md_hlines),MD})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.msg),String,Int64,Vararg{Any, N} where N})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.pkgpath),String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.pluralize),Vector{Int64},String,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.processdoc!),MD,String,Vector{Any}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.processdocs),Vector{Tuple{Float64, DocSeeker.DocObj}}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.processval!),Any,String,Vector{Any}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.processval!),Function,String,Vector{Any}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.project_info)})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.project_status)})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.realpath′),String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMD),Markdown.Admonition})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMD),Markdown.BlockQuote})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMD),Markdown.Code})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMD),Markdown.Footnote})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMD),Markdown.Header{1}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMD),Markdown.Header{2}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMD),Markdown.HorizontalRule})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMD),Markdown.List})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMD),Markdown.Paragraph})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMDinline),Markdown.Bold})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMDinline),Markdown.Code})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMDinline),Markdown.Footnote})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMDinline),Markdown.Image})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMDinline),Markdown.Italic})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMDinline),Markdown.LaTeX})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMDinline),Markdown.Link})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMDinline),String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.renderMDinline),Vector{Any}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.render′),Juno.Inline,Atom.Undefined})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.render′),Juno.Inline,Function})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.render′),Juno.Inline,Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.render′),Juno.Inline,Module})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.render′),Juno.Inline,Nothing})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.render′),Juno.Inline,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.render′),Juno.Inline,Type})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.replcompletionadapter),String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.rt_inf),Any,Method,Type})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.trim),Vector{Float64},Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.withpath),Function,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Any})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Atom.Undefined})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Base.EnvDict})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Complex{Bool}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Dict{Method, Any}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Dict{String, Any}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Dict{String, Dict{String, Vector{Atom.GotoItem}}}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Dict{String, String}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Dict{String, Vector{String}}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,ErrorException})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Float16})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Float32})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Float64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Function})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Irrational{:π}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Irrational{:ℯ}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Module})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,OrderedCollections.OrderedDict{String, Union{NamedTuple{(:rt, :desc), Tuple{String, String}}, NamedTuple{(:f, :m, :tt), Tuple{Any, Method, Type}}}}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Regex})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Type})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,UInt32})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Vector{Any}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Vector{String}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wsicon),Module,Symbol,Vector{Symbol}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wstype),Module,Symbol,Any})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wstype),Module,Symbol,Atom.Undefined})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wstype),Module,Symbol,ErrorException})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wstype),Module,Symbol,Function})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wstype),Module,Symbol,Module})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Atom.wstype),Module,Symbol,Type})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.Broadcast.broadcasted),Function,Vector{Atom.ActualLocalBinding}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.Broadcast.copyto_nonleaf!),Vector{Dict{Symbol, Any}},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1}, Tuple{Base.OneTo{Int64}}, typeof(Atom.localdatatip), Tuple{Base.Broadcast.Extruded{Vector{Atom.ActualLocalBinding}, Tuple{Bool}, Tuple{Int64}}, Base.RefValue{SubString{String}}, Int64}},Base.OneTo{Int64},Int64,Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.Broadcast.copyto_nonleaf!),Vector{Int64},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1}, Tuple{Base.OneTo{Int64}}, typeof(Atom.localdatatip), Tuple{Base.Broadcast.Extruded{Vector{Atom.ActualLocalBinding}, Tuple{Bool}, Tuple{Int64}}, Base.RefValue{SubString{String}}, Int64}},Base.OneTo{Int64},Int64,Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.Broadcast.copyto_nonleaf!),Vector{NamedTuple{(:name, :path), Tuple{String, String}}},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1}, Tuple{Base.OneTo{Int64}}, typeof(Atom.project_info), Tuple{Base.Broadcast.Extruded{Vector{String}, Tuple{Bool}, Tuple{Int64}}}},Base.OneTo{Int64},Int64,Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.Broadcast.copyto_nonleaf!),Vector{Nothing},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1}, Tuple{Base.OneTo{Int64}}, typeof(Atom.outlineitem), Tuple{Base.Broadcast.Extruded{Vector{Atom.ToplevelItem}, Tuple{Bool}, Tuple{Int64}}}},Base.OneTo{Int64},Int64,Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.Broadcast.copyto_nonleaf!),Vector{OutlineItem},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1}, Tuple{Base.OneTo{Int64}}, typeof(Atom.outlineitem), Tuple{Base.Broadcast.Extruded{Vector{Atom.ToplevelItem}, Tuple{Bool}, Tuple{Int64}}}},Base.OneTo{Int64},Int64,Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.Broadcast.copyto_nonleaf!),Vector{Union{Nothing, OutlineItem}},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1}, Tuple{Base.OneTo{Int64}}, typeof(Atom.outlineitem), Tuple{Base.Broadcast.Extruded{Vector{Atom.ToplevelItem}, Tuple{Bool}, Tuple{Int64}}}},Base.OneTo{Int64},Int64,Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.Broadcast.materialize),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1}, Nothing, typeof(Atom.completion), Tuple{Base.RefValue{Module}, Vector{FuzzyCompletions.Completion}, Base.RefValue{String}}}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.Broadcast.restart_copyto_nonleaf!),Vector{Union{Nothing, OutlineItem}},Vector{Nothing},Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1}, Tuple{Base.OneTo{Int64}}, typeof(Atom.outlineitem), Tuple{Base.Broadcast.Extruded{Vector{Atom.ToplevelItem}, Tuple{Bool}, Tuple{Int64}}}},OutlineItem,Int64,Base.OneTo{Int64},Int64,Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.collect_to!),Vector{Any},Base.Generator{Vector{Any}, typeof(Atom.renderMDinline)},Int64,Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.collect_to!),Vector{Hiccup.Node},Base.Generator{Vector{Any}, typeof(Atom.renderMD)},Int64,Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.collect_to_with_first!),Vector{Dict{Symbol, Any}},Dict{Symbol, Any},Base.Generator{Vector{DocSeeker.DocObj}, typeof(Atom.renderitem)},Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.collect_to_with_first!),Vector{Hiccup.Node{:a}},Hiccup.Node{:a},Base.Generator{Vector{Any}, typeof(Atom.renderMDinline)},Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.collect_to_with_first!),Vector{Hiccup.Node{:code}},Hiccup.Node{:code},Base.Generator{Vector{Any}, typeof(Atom.renderMDinline)},Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.collect_to_with_first!),Vector{Hiccup.Node{:div}},Hiccup.Node{:div},Base.Generator{Vector{Any}, typeof(Atom.renderMD)},Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.collect_to_with_first!),Vector{Hiccup.Node{:h1}},Hiccup.Node{:h1},Base.Generator{Vector{Any}, typeof(Atom.renderMD)},Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.collect_to_with_first!),Vector{Hiccup.Node{:h2}},Hiccup.Node{:h2},Base.Generator{Vector{Any}, typeof(Atom.renderMD)},Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.collect_to_with_first!),Vector{Hiccup.Node{:hr}},Hiccup.Node{:hr},Base.Generator{Vector{Any}, typeof(Atom.renderMD)},Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.collect_to_with_first!),Vector{Hiccup.Node{:img}},Hiccup.Node{:img},Base.Generator{Vector{Any}, typeof(Atom.renderMDinline)},Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.collect_to_with_first!),Vector{Hiccup.Node{:pre}},Hiccup.Node{:pre},Base.Generator{Vector{Any}, typeof(Atom.renderMD)},Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.collect_to_with_first!),Vector{Hiccup.Node{:p}},Hiccup.Node{:p},Base.Generator{Vector{Any}, typeof(Atom.renderMD)},Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.collect_to_with_first!),Vector{Hiccup.Node{:strong}},Hiccup.Node{:strong},Base.Generator{Vector{Any}, typeof(Atom.renderMDinline)},Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Base.collect_to_with_first!),Vector{String},String,Base.Generator{Vector{Any}, typeof(Atom.renderMDinline)},Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),Dict{Any, Any}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),Dict{Symbol, Any}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),Hiccup.Node{:a}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),Hiccup.Node{:blockquote}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),Hiccup.Node{:em}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),Hiccup.Node{:h1}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),Hiccup.Node{:h2}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),Hiccup.Node{:hr}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),Hiccup.Node{:img}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),Hiccup.Node{:li}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),Hiccup.Node{:pre}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),Hiccup.Node{:p}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),Hiccup.Node{:strong}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),Hiccup.Node{:td}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),Hiccup.Node{:tr}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),Hiccup.Node{:ul}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),Method})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Juno.view),SubString{String}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Media.render),Juno.Inline,Atom.EvalError{StackOverflowError}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Media.render),Juno.Inline,Function})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Media.render),Juno.Inline,Hiccup.Node{:div}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Media.render),Juno.Inline,Hiccup.Node{:span}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Media.render),Juno.Inline,Juno.Model})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Media.render),Juno.Inline,Module})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Media.render),Juno.Inline,Symbol})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Media.render),Juno.Inline,Text{String}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(Media.render),Juno.Inline,Type})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(clearsymbols)})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(convert),Type{Union{Nothing, Atom.Binding}},Atom.Binding})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(convert),Type{Vector{OutlineItem}},Vector{Nothing}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(convert),Type{Vector{OutlineItem}},Vector{OutlineItem}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(convert),Type{Vector{OutlineItem}},Vector{Union{Nothing, OutlineItem}}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(delete!),Dict{String, Dict{String, Vector{Atom.GotoItem}}},String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(findfirst),Function,Vector{Atom.CompletionSuggestion}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(getdocs),Module,String,Module})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(getdocs),Module,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(getfield′),Any,String,Atom.Undefined})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(getfield′),Any,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(getfield′),Any,Symbol,Atom.Undefined})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(getfield′),Any,Symbol})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(getfield′),Module,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(getfield′),Module,Symbol,Function})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(getfield′),Module,Symbol})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(getindex),Dict{String, Vector{Atom.GotoItem}},String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(getindex),Vector{Atom.CompletionSuggestion},Vector{Int64}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(getproperty),Atom.GotoItem,Symbol})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(globaldatatip),String,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(globalgotoitems),String,Module,Nothing,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(globalgotoitems),String,Module,String,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(globalgotoitems),String,String,String,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(in),OutlineItem,Set{OutlineItem}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isempty),Vector{Atom.ToplevelItem}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(ismacro),Function})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(ismacro),String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),Atom.Undefined})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),Base.RefValue{Bool}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),Base.RefValue{Tuple{String, Int64}}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),Dict{Method, Any}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),Dict{String, Any}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),Dict{String, Dict{String, Vector{Atom.GotoItem}}}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),Dict{String, String}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),Dict{String, Vector{String}}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),Function})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),HTML{String}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),Module})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),OrderedCollections.OrderedDict{String, Union{NamedTuple{(:rt, :desc), Tuple{String, String}}, NamedTuple{(:f, :m, :tt), Tuple{Any, Method, Type}}}}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),Regex})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),Type})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),Vector{Any}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),Vector{String}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(isundefined),Vector{Symbol}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(length),Base.KeySet{String, Dict{String, Dict{String, Vector{Atom.GotoItem}}}}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(length),Base.KeySet{String, Dict{String, Vector{Atom.GotoItem}}}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(map),Function,Vector{Atom.CompletionSuggestion}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(map),Function,Vector{Atom.GotoItem}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(map),Function,Vector{OutlineItem}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(moduledefinition),Module})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(modulefiles),Module})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(modulefiles),String,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(regeneratesymbols)})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(searchcodeblocks),MD})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(searchdocs′),String,Bool,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(searchdocs′),String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(setindex!),Vector{OutlineItem},OutlineItem,Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(similar),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1}, Tuple{Base.OneTo{Int64}}, typeof(Atom.localdatatip), Tuple{Base.Broadcast.Extruded{Vector{Atom.ActualLocalBinding}, Tuple{Bool}, Tuple{Int64}}, Base.RefValue{SubString{String}}, Int64}},Type{Dict{Symbol, Any}}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(similar),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1}, Tuple{Base.OneTo{Int64}}, typeof(Atom.outlineitem), Tuple{Base.Broadcast.Extruded{Vector{Atom.ToplevelItem}, Tuple{Bool}, Tuple{Int64}}}},Type{Nothing}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(similar),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1}, Tuple{Base.OneTo{Int64}}, typeof(Atom.outlineitem), Tuple{Base.Broadcast.Extruded{Vector{Atom.ToplevelItem}, Tuple{Bool}, Tuple{Int64}}}},Type{OutlineItem}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(similar),Base.Broadcast.Broadcasted{Base.Broadcast.DefaultArrayStyle{1}, Tuple{Base.OneTo{Int64}}, typeof(Atom.project_info), Tuple{Base.Broadcast.Extruded{Vector{String}, Tuple{Bool}, Tuple{Int64}}}},Type{NamedTuple{(:name, :path), Tuple{String, String}}}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(sprint),Function,Base.Generator{CSTParser.EXPR, typeof(Atom.str_value)}})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(strlimit),String,Int64,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(strlimit),String,Int64})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(toplevelitems),String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(updatesymbols),String,Nothing,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(updatesymbols),String,String,String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(use_compiled_modules)})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(vcat),OutlineItem,OutlineItem,OutlineItem,Vararg{OutlineItem, N} where N})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(workspace),String})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(|>),Vector{Atom.CompletionSuggestion},typeof(length)})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(|>),Vector{Atom.GotoItem},typeof(isempty)})); catch err; @debug err; end
    try; @assert(Base.precompile(Tuple{typeof(|>),Vector{Atom.ToplevelItem},typeof(length)})); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#113#114")) && Base.precompile(Tuple{getfield(Atom, Symbol("#113#114")),Vector{Any}}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#119#120")) && Base.precompile(Tuple{getfield(Atom, Symbol("#119#120")),Hiccup.Node{:table}}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#119#120")) && Base.precompile(Tuple{getfield(Atom, Symbol("#119#120")),Juno.Model}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#127#128")) && Base.precompile(Tuple{getfield(Atom, Symbol("#127#128")),Text{String}}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#184#185")) && Base.precompile(Tuple{getfield(Atom, Symbol("#184#185"))}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#191#196")) && Base.precompile(Tuple{getfield(Atom, Symbol("#191#196"))}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#192#197")) && Base.precompile(Tuple{getfield(Atom, Symbol("#192#197"))}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#204#209")) && Base.precompile(Tuple{getfield(Atom, Symbol("#204#209"))}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#218#223")) && Base.precompile(Tuple{getfield(Atom, Symbol("#218#223"))}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#226#227")) && Base.precompile(Tuple{getfield(Atom, Symbol("#226#227")),Base.MethodList}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#226#227")) && Base.precompile(Tuple{getfield(Atom, Symbol("#226#227")),MD}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#279#281")) && Base.precompile(Tuple{getfield(Atom, Symbol("#279#281")),FuzzyCompletions.DictCompletion}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#279#281")) && Base.precompile(Tuple{getfield(Atom, Symbol("#279#281")),FuzzyCompletions.KeywordCompletion}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#279#281")) && Base.precompile(Tuple{getfield(Atom, Symbol("#279#281")),FuzzyCompletions.MethodCompletion}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#279#281")) && Base.precompile(Tuple{getfield(Atom, Symbol("#279#281")),FuzzyCompletions.ModuleCompletion}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#279#281")) && Base.precompile(Tuple{getfield(Atom, Symbol("#279#281")),FuzzyCompletions.PathCompletion}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#279#281")) && Base.precompile(Tuple{getfield(Atom, Symbol("#279#281")),FuzzyCompletions.PropertyCompletion}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#39#40")) && Base.precompile(Tuple{getfield(Atom, Symbol("#39#40"))}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#43#44")) && Base.precompile(Tuple{getfield(Atom, Symbol("#43#44")),String}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#45#47")) && Base.precompile(Tuple{getfield(Atom, Symbol("#45#47")),String}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#61#62")) && Base.precompile(Tuple{getfield(Atom, Symbol("#61#62"))}); catch err; @debug err; end
    try; isdefined(Atom, Symbol("#r#109")) && Base.precompile(Tuple{getfield(Atom, Symbol("#r#109")),Juno.Link}); catch err; @debug err; end
    try; @assert(let fbody = try __lookup_kwbody__(which(Atom.fixpath, (String,))) catch missing end
        if !ismissing(fbody)
            precompile(fbody, (String,String,typeof(Atom.fixpath),String,))
        end
    end); catch err; @debug err; end
    try; @assert(let fbody = try __lookup_kwbody__(which(sprint, (Function,Atom.CompletionSuggestion,))) catch missing end
        if !ismissing(fbody)
            precompile(fbody, (Nothing,Int64,typeof(sprint),Function,Atom.CompletionSuggestion,))
        end
    end); catch err; @debug err; end
end
