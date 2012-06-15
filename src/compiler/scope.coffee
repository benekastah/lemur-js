L = lemur
C = L.compiler

class C.Scope
  constructor: ->
    @last_scope = Scope.current_scope()
    @vars = []
    Scope.push_scope this
    
  def_var: (_var) ->
    for v in @vars
      if v.name is _var.name
        _var.error_cant_redefine()
    @vars.push _var
    
  var_defined: (_var) ->
    for v in @vars
      if v.name is _var.name
        found = true
        break
    if not found
      if @last_scope?
        @last_scope.set_var _var
      else
        false
    
  set_var: (_var) ->
    if not @var_defined _var
      _var.error_cant_set()
  
  @new_scope = ->
    @push_scope new C.Scope()
  
  @push_scope = (scope) ->
    @stack.push scope
    scope
    
  @pop_scope = -> @stack.pop()
  
  @current_scope = -> @stack[@stack.length - 1]
  
  @stack = []
  @global_scope = new Scope()