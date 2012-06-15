L = lemur
C = L.compiler

class C.String extends C.Construct
  constructor: (@value) ->
    super
    
  compile: ->
    value = @value.replace /'/, "\\'"
    "'#{value}'"