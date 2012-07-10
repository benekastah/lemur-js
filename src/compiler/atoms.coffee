class C.Atom extends C.Construct
  constructor: (y, yy) ->
    super null, y or yy

## Null & Undefined
class C.Null extends C.Atom
  compile: -> "null"
  
class C.Undefined extends C.Atom
  compile: -> "void(0)"

## Booleans
class C.Boolean extends C.Atom

class C.True extends C.Boolean
  compile: -> "true"

class C.False extends C.Boolean
  compile: -> "false"

class C.This extends C.Construct
  compile: -> "this"