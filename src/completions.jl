### baseline completions ###

handle("completions") do data
  @destruct [
    # general
    line,
    mod || "Main",
    path || nothing,
    # local context
    context || "",
    row || 1,
    startRow || 0,
    column || 1,
    # configurations
    force || false
  ] = data

  withpath(path) do
    basecompletionadapter(
      # general
      line, mod,
      # local context
      context, row - startRow, column,
      # configurations
      force
    )
  end
end

using REPL.REPLCompletions

const CompletionSuggetion = Dict{Symbol, String}

# as an heuristic, suppress completions if there are over 500 completions,
# ref: currently `completions("", 0)` returns **1132** completions as of v1.3
const SUPPRESS_COMPLETION_THRESHOLD = 500

# autocomplete-plus only shows at most 200 completions
# ref: https://github.com/atom/autocomplete-plus/blob/master/lib/suggestion-list-element.js#L49
const MAX_COMPLETIONS = 200

const DESCRIPTION_LIMIT = 200

function basecompletionadapter(
  # general
  line, m = "Main",
  # local context
  context = "", row = 1, column = 1,
  # configurations
  force = false
)
  mod = getmodule(m)

  cs, replace, shouldcomplete = try
    completions(line, lastindex(line), mod)
  catch err
    # might error when e.g. type inference fails
    REPLCompletions.Completion[], 1:0, false
  end

  # suppress completions if there are too many of them unless activated manually
  # e.g. when invoked with `$|`, `(|`, etc.
  # TODO: check whether `line` is a valid text to complete in frontend
  if !force && length(cs) > SUPPRESS_COMPLETION_THRESHOLD
    cs = REPLCompletions.Completion[]
    replace = 1:0
  end

  # initialize suggestions with local completions so that they show up first
  prefix = line[replace]
  comps = if force || !isempty(prefix)
    filter!(let p = prefix
      c -> startswith(c[:text], p)
    end, localcompletions(context, row, column, prefix))
  else
    CompletionSuggetion[]
  end

  cs = cs[1:min(end, MAX_COMPLETIONS - length(comps))]
  afterusing = REPLCompletions.afterusing(line, Int(first(replace))) # need `Int` for correct dispatch on x86
  for c in cs
    if afterusing
      c isa REPLCompletions.PackageCompletion || continue
    end
    push!(comps, completion(mod, c, prefix))
  end

  return comps
end

completion(mod, c, prefix) = CompletionSuggetion(
  :replacementPrefix  => prefix,
  # suggestion body
  :text               => completiontext(c),
  :type               => completiontype(c),
  :icon               => completionicon(c),
  :rightLabel         => completionmodule(mod, c),
  :leftLabel          => completionreturntype(c),
  :descriptionMoreURL => completionurl(c),
  # for `getSuggestionDetailsOnSelect` API
  :detailtype         => completiondetailtype(c)
)

completiontext(c) = completion_text(c)
completiontext(c::REPLCompletions.MethodCompletion) = begin
  ct = completion_text(c)
  m = match(r"^(.*) in .*$", ct)
  m isa Nothing ? ct : m[1]
end
completiontext(c::REPLCompletions.DictCompletion) = rstrip(completion_text(c), [']', '"'])
completiontext(c::REPLCompletions.PathCompletion) = rstrip(completion_text(c), '"')

completionreturntype(c) = ""
completionreturntype(c::REPLCompletions.PropertyCompletion) = begin
  isdefined(c.value, c.property) || return ""
  shortstr(typeof(getproperty(c.value, c.property)))
end
completionreturntype(c::REPLCompletions.FieldCompletion) =
  shortstr(fieldtype(c.typ, c.field))
completionreturntype(c::REPLCompletions.DictCompletion) =
  shortstr(valtype(c.dict))
completionreturntype(::REPLCompletions.PathCompletion) = "Path"

completionurl(c) = ""
completionurl(c::REPLCompletions.ModuleCompletion) = begin
  mod, name = c.parent, c.mod
  val = getfield′(mod, name)
  if val isa Module # module info
    urimoduleinfo(parentmodule(val) == val || val ∈ (Base, Core) ? name : "$mod.$name")
  else
    uridocs(mod, name)
  end
end
completionurl(c::REPLCompletions.MethodCompletion) = uridocs(c.method.module, c.method.name)
completionurl(c::REPLCompletions.PackageCompletion) = urimoduleinfo(c.package)
completionurl(c::REPLCompletions.KeywordCompletion) = uridocs("Main", c.keyword)

completionmodule(mod, c) = shortstr(mod)
completionmodule(mod, c::REPLCompletions.ModuleCompletion) = shortstr(c.parent)
completionmodule(mod, c::REPLCompletions.MethodCompletion) = shortstr(c.method.module)
completionmodule(mod, c::REPLCompletions.FieldCompletion) = shortstr(c.typ) # predicted type
completionmodule(mod, ::REPLCompletions.KeywordCompletion) = ""
completionmodule(mod, ::REPLCompletions.PathCompletion) = ""

completiontype(c) = "variable"
completiontype(c::REPLCompletions.ModuleCompletion) = begin
  ct = completion_text(c)
  ismacro(ct) && return "snippet"
  mod, name = c.parent, Symbol(ct)
  val = getfield′(mod, name)
  wstype(mod, name, val)
end
completiontype(::REPLCompletions.MethodCompletion) = "method"
completiontype(::REPLCompletions.PackageCompletion) = "import"
completiontype(::REPLCompletions.PropertyCompletion) = "property"
completiontype(::REPLCompletions.FieldCompletion) = "property"
completiontype(::REPLCompletions.DictCompletion) = "property"
completiontype(::REPLCompletions.KeywordCompletion) = "keyword"
completiontype(::REPLCompletions.PathCompletion) = "path"

completionicon(c) = ""
completionicon(c::REPLCompletions.ModuleCompletion) = begin
  ismacro(c.mod) && return "icon-mention"
  mod, name = c.parent, Symbol(c.mod)
  val = getfield′(mod, name)
  wsicon(mod, name, val)
end
completionicon(::REPLCompletions.DictCompletion) = "icon-key"
completionicon(::REPLCompletions.PathCompletion) = "icon-file"

completiondetailtype(c) = ""
completiondetailtype(::REPLCompletions.ModuleCompletion) = "module"
completiondetailtype(::REPLCompletions.KeywordCompletion) = "keyword"

const METHODCOMP_DETAIL_DELIM = ' '

function completiondetailtype(c::REPLCompletions.MethodCompletion)
  tt = Base.tuple_type_tail(c.input_types)

  # pass string representations of this `MethodCompletion` so that we can reconstruct the necessary information lazily
  return join([
    repr(c.func),
    repr(tt), # input tuple type
    repr(hash(c.method)) # hash string to identify this method
  ], METHODCOMP_DETAIL_DELIM)
end

function localcompletions(context, row, col, prefix)
  ls = locals(context, row, col)
  lines = split(context, '\n')
  return localcompletion.(ls, prefix, Ref(lines))
end
function localcompletion(l, prefix, lines)
  desc = if l.verbatim == l.name
    # show a line as is if ActualLocalBinding.verbatim is not so informative
    lines[l.line]
  else
    l.verbatim
  end |> s -> strlimit(s, DESCRIPTION_LIMIT)
  return CompletionSuggetion(
    :replacementPrefix  => prefix,
    # suggestion body
    :text               => l.name,
    :type               => (type = static_type(l)) == "variable" ? "attribute" : type,
    :icon               => (icon = static_icon(l)) == "v" ? "icon-chevron-right" : icon,
    :rightLabel         => l.root,
    :description        => desc,
    # for `getSuggestionDetailsOnSelect` API
    :detailtype         => "", # shouldn't complete
  )
end

### completion details on selection ###

handle("completiondetail") do _comp
  comp = Dict(Symbol(k) => v for (k, v) in _comp)
  completiondetail!(comp)
  return comp
end

function completiondetail!(comp)
  isempty(comp[:detailtype]) && return comp

  if comp[:detailtype] == "module"
    completiondetail_module!(comp)
  elseif comp[:detailtype] == "keyword"
    completiondetail_keyword!(comp)
  else # detail for method completion
    completiondetail_method!(comp)
  end

  comp[:detailtype] = ""
end

function completiondetail_module!(comp)
  mod = getmodule(comp[:rightLabel])
  word = comp[:text]
  cangetdocs(mod, word) || return
  comp[:description] = completiondescription(getdocs(mod, word))
end

function completiondetail_keyword!(comp)
  comp[:description] = completiondescription(getdocs(Main, comp[:text]))
end

const GENSYM_REGEX = r"var\"(.+)\""
using JuliaInterpreter: sparam_syms
using Base.Docs

# NOTE: this is really hacky, find another way to implement this ?
function completiondetail_method!(comp)
  mod = getmodule(comp[:rightLabel])
  f_str, tt_str, fhash_str = split(comp[:detailtype], METHODCOMP_DETAIL_DELIM)
  f_str = split(f_str, '.')[end] # NOTE: strip module prefix (important since module itself can be gensymed)

  # reconstruct function itself handling gensyms
  if (m = match(GENSYM_REGEX, f_str)) !== nothing
    # gensym pattern
    f_sym = Symbol(m.captures[1])
    f_typ = getfield′(mod, f_sym)
    (isundefined(f_typ) || !isdefined(f_typ, :instance)) && return
    f = f_typ.instance
  else
    # ordinary function
    f_sym = Symbol(f_str)
    f = getfield′(mod, f_sym)
    isundefined(f) && return
  end

  # reconstruct a Method object from its hash string
  ms = collect(methods(f))
  (i = findfirst(m -> repr(hash(m)) == fhash_str, ms)) === nothing && return
  m = ms[i]

  comp[:leftLabel] = lazy_rt_inf(f, m, tt_str)

  cangetdocs(mod, f_sym) || return
  docs = try
    Docs.doc(Docs.Binding(mod, f_sym), Base.tuple_type_tail(m.sig))
  catch err
    ""
  end
  comp[:description] = completiondescription(docs)
end

function lazy_rt_inf(@nospecialize(f), m, tt_str)
  try
    world = typemax(UInt) # world age

    # first infer return type using input types
    # NOTE: input types are all concrete
    # - the inference result from them is the best what we can get, and so here we eagerly respect that if inference succeeded
    # - when reconstruct tuple type from its string representation, we don't need to handle UnionAll or stuff, which would make parsing more difficult
    tt_expr = Meta.parse(tt_str; raise = false)
    if !Meta.isexpr(tt_expr, (:incomplete, :error))
      tt = eval(tt_expr)::Type
      if !isempty(tt.parameters)
        inf = Core.Compiler.return_type(f, tt, world)
        inf ∉ (nothing, Any, Union{}) && return shortstr(inf)
      end
    end

    # sometimes method signature can tell the return type by itself
    sparams = Core.svec(sparam_syms(m)...)
    inf = Core.Compiler.typeinf_type(m, m.sig, sparams, Core.Compiler.Params(world))
    inf ∉ (nothing, Any, Union{}) && return shortstr(inf)
  catch err
    # @error err
  end
  return ""
end

using Markdown

completiondescription(docs) = ""
completiondescription(docs::Markdown.MD) = begin
  md = CodeTools.flatten(docs).content
  for part in md
    if part isa Markdown.Paragraph
      desc = Markdown.plain(part)
      occursin("No documentation found.", desc) && return ""
      return strlimit(desc, DESCRIPTION_LIMIT)
    end
  end
  return ""
end
