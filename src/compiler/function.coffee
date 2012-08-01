
class C.Function extends C.Construct
  constructor: ({@name, @args, @body, @autoreturn}, yy) ->
    @name ?= ''
    @args ?= []
    @body ?= []

    if @args not instanceof C.Function.ArgsList
      @args = new C.Function.ArgsList @args, yy

    super

    if @args instanceof C.Array
      @args = @args.items
    
  compile: ->
    scope = new C.Scope()
    
    {to_return, to_return_context} = @will_autoreturn()
    tail_recursive = @autoreturn and
      to_return.value instanceof C.FunctionCall and
      to_return.value.fn instanceof C.Symbol and
      to_return.value.fn.name is @name.name
      
    [args, add_to_body, rest] = @args._compile()
    body = @body
    if tail_recursive
      sym_continue = C.Var.gensym "continue"
      set_continue = new C.Var.Set _var: sym_continue, value: new C.Null()

      fake_args = {}
      fake_arg_defs = []
      arg_redefs = []
      last_arg = @args.length - 1
      for arg, i in @args.args
        if rest and i is last_arg
          arg = rest
        fake_arg = fake_args[arg.name] = C.Var.gensym arg
        fake_arg_defs.push (new C.Var.Set _var: fake_arg, value: to_return.value.args[i])
        arg_redefs.push (new C.Var.Set _var: arg, value: fake_arg, must_exist: false)

      _continuet = new C.Var.Set _var: sym_continue, value: new C.True()
      _continuef = new C.Var.Set _var: sym_continue, value: new C.False()
      fake_fn_call = new C.CommaGroup [fake_arg_defs..., arg_redefs..., _continuet]
      body.unshift _continuef

      to_return.return_disabled = true
      to_return_context.tail_node fake_fn_call
      fake_fn_call.returnedConstruct.disabled = true
      sym_result = C.Var.gensym "result"

      sym_fn = C.Var.gensym "fn"
      fn = new C.Var.Set _var: sym_fn, value: (new C.Function body: body)
      result = new C.Var.Set {
        _var: sym_result
        value: (new C.FunctionCall fn: sym_fn, scope: new C.This())
      }

      ret = new C.If condition: (new C.Not sym_continue), then: new C.ReturnedConstruct sym_result
      _while = new C.WhileLoop condition: new C.True(), body: [result, ret]
      body = [set_continue, fn, _while]

      
    c_name = if L.core.to_type(@name) is "string" then @name else @name._compile()
    c_args = for arg in args then arg._compile()
    c_body = for stmt, i in body then stmt._compile()
    c_body = "#{c_body.join ';\n  '};"
    c_body = if add_to_body? then "#{add_to_body._compile()};\n  #{c_body}" else c_body

    var_stmt = scope.var_stmt()
    """
    function #{c_name}(#{c_args.join ", "}) {
      #{var_stmt}#{c_body}
    }
    """

  will_autoreturn: ->
    if @autoreturn and @body.length
      to_return = @body.pop()
      to_return = to_return.should_return()
      @body.push to_return
      ret =
        to_return: to_return.tail_node()
        to_return_context: to_return
    ret or new C.Null()



class C.Function.ArgsList extends C.Construct
  slice_fn: "Array.prototype.slice.call"
  constructor: (@args) ->
    super

  compile: ->
    args = @args.slice?() or @args.items?.slice()
    if args.length
      rest = args.pop()
      if rest not instanceof C.Rest
        args.push rest
        rest = null
      else
        rest = rest.sym

      if rest?
        rest = new C.Var rest, rest.yy
        c_rest = rest._compile()
        add_to_body = new C.Raw "#{c_rest} = #{@slice_fn}(arguments, #{args.length})"

    [args, add_to_body, rest]




class C.FunctionCall extends C.Construct
  constructor: ({@fn, @args, @scope, @apply, @instantiate}, yy) ->
    @call = !!@scope
    @scope ?= new C.Null null, yy
    @args or= []

  compile: ->
    c_fn = @fn._compile()
    if @fn not instanceof C.Symbol
      c_fn = "(#{c_fn})"

    if @apply or @call
      args = [@scope].concat(@args)
    else
      args = @args
    c_args = for arg in args then arg._compile()

    instantiate = if @instantiate then "new " else ""

    "#{instantiate}#{c_fn}#{if @apply then '.apply' else if @call then '.call' else ''}(#{c_args.join ', '})"

