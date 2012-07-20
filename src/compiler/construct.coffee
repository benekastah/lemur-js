# Generic class for all javascript constructs
class C.Construct
  constructor: (@value, yy_or_node_or_num) ->
    if yy_or_node_or_num instanceof Construct
      @transfer_node = yy_or_node_or_num
      @yy = yy_or_node_or_num.yy
    else if (L.core.to_type yy_or_node_or_num) is "number"
      @yy =
        lexer:
          yylineno: yy_or_node_or_num
    else
      @yy = yy_or_node_or_num
      
    @line_number = @yy?.lexer?.yylineno
    
  compile: ->
    if @value?
      "#{@value}"
    else
      "null"

  _compile: -> @compile arguments...

  error: (message) ->
    filename = C.current_filename
    location = ""
    type = ""
    if filename?
      location += " in #{filename}"
    if @line_number?
      location += " at line #{@line_number}"
    if @constructor.name?
      type = "#{@constructor.name}"
      
    throw "#{type}Error#{location}: #{message}"
    
  should_return: -> new C.ReturnedConstruct this, @yy

  Noop: class Noop
    constructor: (c) -> @constructor = c

  clone: ->
    Class = @constructor
    p = Class::
    np = @Noop::
    @Noop:: = p
    cl = new Noop Class
    @Noop:: = np
    for own prop, val of this
      val = val?.clone?() ? val
      cl[prop] = val
    cl

class C.ReturnedConstruct extends C.Construct
  compile: ->
    c_value = @value._compile()
    if not @disabled
      "return #{c_value}"
    else
      c_value

  tail_node: (node) ->
    if not node?
      this
    else
      if node instanceof C.ReturnedConstruct
        node = node.value
      @value = node
      node.returnedConstruct = this

  should_return: -> this