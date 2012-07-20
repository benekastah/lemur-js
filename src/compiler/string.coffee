
class C.String extends C.Construct
  constructor: (@value) ->
    super
    
  compile: ->
    value = @value.replace /'/, "\\'"
    "'#{value}'"

  toString: -> @compile()