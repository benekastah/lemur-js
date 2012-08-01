
class C.CodeFragment extends C.Construct
  constructor: (@statements) ->
    super

  compile: ->
    c_statements = for stmt in @statements then stmt._compile()
    "#{c_statements.join ';\n'}"