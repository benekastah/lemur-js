
class C.If extends C.Construct
  constructor: ({@condition, @then, @_else}) ->
    super

  compile: ->
    c_cond = @condition.compile()
    c_then = @then.compile()
    ret = """
    if (#{c_cond}) {
      #{c_then}
    }
    """

    if @_else
      c_else = @_else.compile()
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