L = lemur
C = L.compiler

class C.Object extends C.Construct
  constructor: (o=[]) ->
    super
    @property_value_pairs = o
    
  compile: ->
    pairs = for [prop, val] in @property_value_pairs
      "#{prop.compile()}: #{val.compile()}"
    "{ #{pairs.join ',\n  '} }"
      
    