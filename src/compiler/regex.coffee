L = lemur
C = L.compiler

class C.Regex extends C.Construct
  constructor: ({@pattern, @modifiers}) ->
    super
    
  compile: ->
    "/#{@pattern}/#{@modifiers}"