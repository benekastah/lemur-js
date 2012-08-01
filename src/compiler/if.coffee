
class C.If extends C.Construct
  constructor: ({@condition, @then, @_else}) ->
    super

  compile: ->
    c_cond = @condition._compile()
    c_then = @then._compile()
    ret = """
    if (#{c_cond}) {
      #{c_then}
    }
    """

    if @_else
      c_else = @_else._compile()
      ret = """
        #{ret} else {
          #{c_else}
        }
      """

    ret

  should_return: ->
    @then = @then.should_return()
    @_else = @_else.should_return() if @_else
    this

  tail_node: ->
    if @_else?
      @_else.tail_node arguments...
    else
      @then.tail_node arguments...

class C.IfTernary extends C.If
  constructor: ({@_else}, yy) ->
    super
    @_else ?= new C.Null yy

  compile: ->
    c_cond = @condition._compile()
    c_then = @then._compile()
    c_else = @_else._compile()
    "(#{c_cond} ? #{c_then} : #{c_else})"

  should_return: ->
    super
    @then.disabled = true
    @_else?.disabled = true
    ret = new C.ReturnedConstruct this
    ret.tail_node = => @tail_node arguments...
    ret
