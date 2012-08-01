
class C.String extends C.Construct
  constructor: (@value) ->
    super
    
  compile: ->
    value = @value.replace(/'/g, "\\'").replace(/\n/g, '\\n')
    "'#{value}'"

  toString: -> @compile()