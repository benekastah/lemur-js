
class C.Rest extends C.Construct
  constructor: (@sym) ->
    super
    if @sym instanceof C.String
      @sym = new C.Symbol @sym.value, @sym.yy
    else if (core.to_type @sym) is "string"
      @sym = new C.Symbol @sym, @yy
      
    if @sym not instanceof C.Symbol
      @error "A rest param must be a symbol." 
    
  compile: -> @sym._compile()