class C.Loop extends C.Construct
  @BREAK = {compile: -> "break"}
  @CONTINUE = {compile: -> "continue"}



class C.ForLoop extends C.Loop
  constructor: ({condition, @body}) ->
    [@a, @b, @c] = condition
    super
    
  compile: ->
    c_a = @a._compile()
    c_b = @b._compile()
    c_c = @c._compile()
    c_body = for item in @body then item._compile()
    """
    for (#{c_a}; #{c_b}; #{c_c}) {
    	#{c_body.join ';\n  '};
    }
    """



class C.ForEachLoop extends C.ForLoop
  constructor: ({@collection, @body}, yy) ->
    i = C.Var.gensym "i", yy
    vlen = C.Var.gensym "len", yy
    len = new C.PropertyAccess [@collection, C.Symbol "length"]
    a = new C.Comma (C.Var.Set var: i, value: (C.Number 0, yy)), (C.Var.Set var: vlen, value: len)
    b = new C.LT [i, len]
    c = new C.PostIncr i
    super [a, b, c], yy



class C.ForInLoop extends C.Loop
  constructor: ({@property, @object, @body}) ->
    super

  compile: ->
    c_property = @property._compile()
    c_object = @object._compile()
    c_body = for item in @body then item._compile()
    """
    for (#{c_property} in #{c_object}) {
      #{c_body.join ';\n  '};
    }
    """



class C.WhileLoop extends C.Loop
  constructor: ({@condition, @body}) ->
    super

  compile: ->
    c_condition = @condition._compile()
    c_body = for item in @body then item._compile()
    """
    while (#{c_condition}) {
      #{c_body.join ';\n  '};
    }
    """



class C.DoWhileLoop extends C.Loop
  constructor: ({@condition, @body}) ->
    super

  compile: ->
    c_condition = @condition._compile()
    c_body = for item in @body then item._compile()
    """
    do {
      #{c_body.join ';\n  '};
    } while (#{c_condition})
    """