
class C.Rest extends C.Construct
  constructor: (@sym) ->
    if @sym not instanceof C.Symbol
      @error "A rest param must be a symbol."
    super
    
  compile: -> @sym._compile()