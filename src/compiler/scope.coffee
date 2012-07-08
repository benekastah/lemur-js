class C.Scope
  constructor: (config={}) ->
    {push_to_current} = config
    #console.log "C.current_context", C.current_context
    @last_scope = C.current_scope()
    @vars = {}
    push_to_current ?= true
    C.push_scope this if push_to_current
    
  def_var: (_var, val) ->
    if @var_defined _var
      _var.error_cant_redefine()
    @vars[_var.name] = {_var, val}

  var_defined: (_var) -> `_var.name in this.vars`
    
  set_var: (_var, val) ->
    if not @var_defined _var
      _var.error_cant_set()
    @vars[_var.name].val = val

  get_val: (_var) -> @vars[_var.name]?.val

  quiet_def_var: (_var) -> try @def_var _var

  var_stmt: ->
    if Object.keys(@vars).length
      c_vars = for own name, {_var} of @vars then _var._compile()
      "var #{c_vars.join ', '};\n"
    else
      ''