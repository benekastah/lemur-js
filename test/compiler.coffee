puts = p = console.log.bind console

try require '#{__dirname}/../build/lemur'
L = lemur
puts "L", Object.keys(L)

C = L.Compiler
new C()

v = new C.Var "->s"
p v.compile()