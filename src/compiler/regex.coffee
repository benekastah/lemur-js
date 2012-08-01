class C.Regex extends C.Construct
  constructor: ({@pattern, @modifiers}) ->
    super
    if (core.to_type @pattern) is "string"
      @pattern = new C.String @pattern, @yy
    if (core.to_type @modifiers) is "string"
      @modifiers = new C.String @modifiers, @yy
    
  compile: ->
    if @pattern instanceof C.String and @modifiers instanceof C.String
      "/#{@pattern.value}/#{@modifiers?.value ? ''}"
    else
      c_pattern = @pattern._compile()
      c_modifiers = @modifiers?._compile()
      args = [c_pattern]
      if c_modifiers
        args.push c_modifiers
      "new RegExp(#{args.join ', '})"