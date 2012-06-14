require 'coffee-script'
puts = console.log.bind console
Parser = require '../src/parser/parser'

p = new Parser {
  lexer: [
    [/\s+/, "/* skip whitespace */"]
    [/[0-9]+(\.[0-9]+)?\b/, "NUMBER"]
    ["*"]
    ["/"]
    ["-"]
    ["+"]
    ["^"]
    ["("]
    [")"]
    ["PI"]
    ["E"]
    ["<<EOF>>", "EOF"]
    [".", "INVALID"]
  ],
  operators: [
    "left + -"
    "left * /"
    "left ^"
    "left UMINUS"
  ],
  start: "expressions"
  grammar: {
    expressions: [
      ["e EOF"]
    ]
    e: [
      ["e + e", -> $1 + $3]
      ["e - e", -> $1 - $3]
      ["e * e", -> $1 * $3]
      ["e / e", -> $1 / $3]
      ["e ^ e", -> Math.pow $1, $3]
      ["- e", (-> -$2), prec: 'UMINUS']
      ["( e )", -> $2]
      ["NUMBER", -> Number yytext]
      ["E", -> Math.E]
      ["PI", -> Math.PI]
    ]
  }
}

puts p
