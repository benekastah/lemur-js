class C.Object extends C.Construct
  constructor: (pairs = []) ->
    super
    @property_value_pairs = for pair in pairs
      if pair instanceof C.List
        pair.quoted = true
      eval pair._compile()
    
  compile: ->
    pairs = for [prop, val] in @property_value_pairs
      "#{prop._compile()}: #{val._compile()}"
    "{ #{pairs.join ',\n  '} }"
      
class C.ProperyAccess extends C.Construct
  constructor: ([@obj, @props...]) ->
    super

  compile: ->
    base = @obj._compile()
    for prop in @props
      c_prop = prop._compile()
      if prop instanceof C.Var
        base = "#{base}.#{c_prop}"
      else
        base = "#{base}[#{c_prop}]"