
class C.TryCatch extends C.Construct
  constructor: ({@_try, @err_name, @_catch, @_finally}) ->
    @err_name ?= C.Symbol.gensym "err"
    @_try ?= []
    @_catch ?= []
    @_finally ?= []
    super
    
  compile: ->
    c_try = for item in @_try then item._compile()
    c_err_name = @err_name._compile()
    c_catch = for item in @_catch then item._compile()
    c_finally = for item in @_finally then item._compile()

    c_try = if c_try.length then "\n#{c_try.join ';\n'};\n" else ""
    c_catch = if c_catch.length then "\n#{c_catch.join ';\n'};\n" else ""
    c_finally = if c_finally.length then " finally {\n#{c_finally.join ';\n'};\n}" else ""
    "try {#{c_try}} catch (#{c_err_name}) {#{c_catch}}#{c_finally}"

  should_return: ->
    if @_finally.length
      f_last = @_finally.pop()
      @_finally.push f_last.should_return()
    else
      if @_try.length
        t_last = @_try.pop()
        @_try.push t_last.should_return()
      if @_catch.length
        c_last = @_catch.pop()
        @_catch.push c_last.should_return()
    this

  tail_node: ->
    if @_finally.length
      @_finally[@_finally.length - 1]
    else if @_catch.length
      @_catch[@_catch.length - 1]
    else
      @_try[@_try.length - 1]