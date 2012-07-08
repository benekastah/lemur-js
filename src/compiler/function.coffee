class C.Function extends C.Construct
  constructor: ({@name, @args, @body, @autoreturn}) ->
    @name ?= ''
    @args ?= []
    @body ?= []
    super
    
  compile: ->
    scope = new C.Scope()
    
    c_name = if L.core.to_type(@name) is "string" then @name else @name._compile()
    c_args = for arg in @args then arg._compile()
    last_stmt_index = @body.length - 1

    if @autoreturn
      c_body = for stmt, i in @body
        if i is last_stmt_index
          stmt = stmt.should_return()
        stmt._compile()
      
    var_stmt = scope.var_stmt()
    """
    function #{c_name}(#{c_args.join ", "}) {
      #{var_stmt}#{c_body.join ";\n  "};
    }
    """

class C.FunctionCall extends C.Construct
  constructor: ({@fn, @args, @scope, @apply}, yy) ->
    @call = !!@scope
    @scope ?= new C.Null null, yy

  compile: ->
    c_fn = @fn._compile()
    if @fn not instanceof C.Symbol
      c_fn = "(#{c_fn})"

    if @apply or @call
      args = [@scope].concat(@args)
    else
      args = @args
    c_args = for arg in @args then arg._compile()
    "#{c_fn}#{if @apply then '.apply' else if @call then '.call' else ''}(#{c_args.join ', '})"