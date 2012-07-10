
class C.CommaGroup extends C.Construct
  constructor: (@items) ->
    super

  compile: ->
    c_items = for item in @items then item._compile()
    "(#{c_items.join ', '})"