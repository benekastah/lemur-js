L = lemur
C = L.compiler

# Generic class for all javascript constructs
class C.Construct
  constructor: (__, yy_or_node_or_num) ->
    if yy_or_node_or_num instanceof Construct
      @transfer_node = yy_or_node_or_num
      @yy = yy_or_node_or_num.yy
    else if (L.core.to_type yy_or_node_or_num) is "number"
      @yy =
        lexer:
          yylineno: yy_or_node_or_num
    else
      @yy = yy_or_node_or_num
      
    @line_number = @yy?.lexer.yylineno
    
  compile: ->
    if @value?
      "#{@value}"
    else
      "null"
      
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
    
  should_return: ->
    Construct = ->
    Construct:: = this
    class ReturnedConstruct extends Construct
      compile: -> "return #{super}"
      
    new ReturnedConstruct()