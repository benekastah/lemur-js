L = lemur
C = L.compiler

class L.Null extends C.Construct
  compile: -> "null"
  
class L.Undefined extends C.Construct
  compile: -> "void(0)"