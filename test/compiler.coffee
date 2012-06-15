try require '../'
L = lemur
C = L.compiler
puts = p = console.log.bind console

v = new C.Var "->s"
p v.compile()