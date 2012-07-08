class C.Number extends C.Construct
  constructor: (n) ->
    super
    if (L.core.to_type n) is "object"
      o = n
      {value, base} = o
      if base
        n = parseInt value, base
      else
        n = value

    @value = +n
    
  compile: -> "#{@value}"