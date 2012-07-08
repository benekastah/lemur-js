L = lemur

C = class L.Compiler
  constructor: (config={}) ->
    {@predefined, @parent_context} = config

    C.current_context = this
    @scope_stack = @parent_context?.scope_stack.slice() || []
    @new_scope()
    @global_scope = @current_scope()

  new_scope: ->
    @push_scope new C.Scope(push_to_current: false)
  
  push_scope: (scope) ->
    @scope_stack.push scope
    scope
    
  pop_scope: -> @scope_stack.pop()
  
  current_scope: -> @scope_stack[@scope_stack.length - 1]

  find_scope_with_var: (_var) ->
    for scope in @scope_stack.slice().reverse()
      return scope if scope.var_defined _var
    null

  get_var_val: (_var) ->
    scope = @find_scope_with_var _var
    if scope?
      scope.get_val _var

  set_var_val: (_var, val) ->
    scope = @find_scope_with_var _var
    if scope?
      scope.set_var _var, val
    else
      _var.error_cant_set()

  compile: (fn) -> fn.call this

  @current_scope = -> @current_context.current_scope()

  @push_scope = -> @current_context.push_scope arguments...

  @pop_scope = -> @current_context.pop_scope()

  @new_scope = -> @current_context.new_scope arguments...

  @find_scope_with_var = -> @current_context.find_scope_with_var arguments...

  @get_var_val = -> @current_context.get_var_val arguments...

  @set_var_val = -> @current_context.set_var_val arguments...