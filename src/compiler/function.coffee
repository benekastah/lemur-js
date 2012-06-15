L = lemur
C = L.compiler

class C.Function extends C.Construct
  constructor: ({@name, @args, @body}) ->
    @name ?= ''
    @args ?= []
    @body ?= []
    super
    
  compile: ->
    scope = C.Scope.new_scope()
    
    c_args = for arg in @args then arg.compile()
    last_stmt_index = @body.length - 1
    c_body = for stmt, i in @body
      if i is last_stmt_index
        stmt = stmt.should_return()
      stmt.compile()
      
    vars = for _var in scope.vars then _var.compile()
    var_stmt = if vars.length then "var #{vars.join ', '};\n  " else  ''
      
    """
        (function #{@name}(#{c_args.join ", "}) {
          #{var_stmt}#{c_body.join ";\n  "};
        })
        """