class C.Operation extends C.Construct
  constructor: ([@x, @op, @y]) ->
    super
    
  compile: ->
    c_x = @x._compile()
    c_y = @y._compile()
    "#{c_x} #{@op} #{c_y}"

class C.PrefixOperation extends C.Operation
  constructor: ([@x, @op]) ->
    super

  compile: ->
    c_x = @x._compile()
    "#{@op}#{c_x}"

class C.PostfixOperation extends C.Operation
  constructor: ([@x, @op]) ->
    super

  compile: ->
    c_x = @x._compile()
    "#{c_x}#{@op}"

regular_ops = {
  # Math
  Add: "+"
  Subtract: "-"
  Multiply: "*"
  Divide: "/"
  Mod: "%"

  # Comparison
  GT: ">"
  LT: "<"
  GTE: ">="
  LTE: "<="
  Eq3: "==="
  Eq2: "=="
  NotEq3: "!=="
  NotEq2: "!="

  # Logical
  And: "&&"
  Or: "||"

  # Bitwise
  BAnd: "&"
  BOr: "|"
  BXor: "^"
  BLeftShift: "<<"
  BRightShift: ">>"
  BZeroFillRightShift: ">>>"

  #Misc
  Comma: ","
}

prefix_ops = {
  Not: "!"
  BNot: "~"
  PreIncr: "++"
  PreDecr: "--"
  Delete: "delete "
}

postfix_ops = {
  PostIncr: "++"
  PostDecr: "--"
}

for own name, op of regular_ops then do (name, op) ->
  class C[name] extends C.Operation
    constructor: ([x, y], yy) ->
      super [x, op, y], yy

for own name, op of prefix_ops then do (name, op) ->
  class C[name] extends C.PrefixOperation
    constructor: (x, yy) ->
      super [x, op], yy

for own name, op of postfix_ops then do (name, op) ->
  class C[name] extends C.PostfixOperation
    constructor: (x, yy) ->
      super [x, op], yy
