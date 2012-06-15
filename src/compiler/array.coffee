L = lemur
C = L.compiler

class C.Array extends C.Construct
  constructor: (@items) ->
    super
    
  compile: ->
    c_items = for item in @items then item.compile()
    "[#{c_items.join ', '}]"