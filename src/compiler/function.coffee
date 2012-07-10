class C.Function extends C.Construct
  constructor: ({@name, @args, @body, @autoreturn}) ->
    @name ?= ''
    @args ?= []
    @body ?= []
    super
    
  compile: ->
    scope = new C.Scope()
    
    {to_return, to_return_context} = @will_autoreturn()
    tail_recursive = @autoreturn and
      to_return.value instanceof C.FunctionCall and
      to_return.value.fn instanceof C.Symbol and
      to_return.value.fn.name is @name.name
      
    body = @body
    if tail_recursive
      sym_continue = C.Var.gensym "continue"
      fake_args = {}
      fake_arg_defs = []
      arg_redefs = []
      for arg, i in @args
        fake_arg = fake_args[arg.name] = C.Var.gensym arg
        fake_arg_defs.push (new C.Var.Set _var: fake_arg, value: to_return.value.args[i])
        arg_redefs.push (new C.Var.Set _var: arg, value: fake_arg, must_exist: false)

      _continuet = new C.Var.Set _var: sym_continue, value: new C.True()
      _continuef = new C.Var.Set _var: sym_continue, value: new C.False()
      fake_fn_call = new C.CodeFragment (fake_arg_defs.concat arg_redefs, _continuet)
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
      body = [fn, _while]

      
    c_name = if L.core.to_type(@name) is "string" then @name else @name._compile()
    c_args = for arg in @args then arg._compile()
    c_body = for stmt, i in body then stmt._compile()
    var_stmt = scope.var_stmt()
    """
    function #{c_name}(#{c_args.join ", "}) {
      #{var_stmt}#{c_body.join ";\n  "};
    }
    """

  will_autoreturn: ->
    if @autoreturn
      to_return = @body.pop()
      to_return = to_return.should_return()
      @body.push to_return
      ret =
        to_return: to_return.tail_node()
        to_return_context: to_return
    ret or {}

class C.FunctionCall extends C.Construct
  constructor: ({@fn, @args, @scope, @apply}, yy) ->
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
    "#{c_fn}#{if @apply then '.apply' else if @call then '.call' else ''}(#{c_args.join ', '})"