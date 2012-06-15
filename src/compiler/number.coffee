L = lemur
C = L.compiler

class C.Number extends C.Construct
  constructor: (n) ->
    super
    @value = Number n
    
  compile: -> "#{@value}"