require 'coffee-script'
puts = console.log.bind console
parser = require '../src/parser/parser'
JisonParser = (require 'jison').Parser

p = parser {
  lexer: [
    [/\s+/, "/* skip whitespace */"]
    [/[0-9]+(\.[0-9]+)?\b/, "NUMBER"]
    ["*", "MULT"]
    ["/", "DIV"]
    ["-", "MINUS"]
    ["+", "ADD"]
    ["^", "POW"]
    ["(", "OGROUP"]
    [")", "CGROUP"]
    ["PI"]
    ["E"]
    ["<<EOF>>", "EOF"]
    [/./, "INVALID"]
  ],
  operators: [
    "left ADD MINUS"
    "left MULT DIV"
    "left POW"
    "left UMINUS"
  ],
  start: "expressions"
  grammar: {
    expressions: [
      ["e EOF"]
    ]
    e: [
      ["e ADD e", -> $1 + $3]
      ["e MINUS e", -> $1 - $3]
      ["e MULT e", -> $1 * $3]
      ["e DIV e", -> $1 / $3]
      ["e POW e", -> Math.pow $1, $3]
      ["MINUS e", (-> -$2), prec: 'UMINUS']
      ["OGROUP e CGROUP", -> $2]
      ["NUMBER", -> Number yytext]
      ["E", -> Math.E]
      ["PI", -> Math.PI]
    ]
  }
}

puts p.parse "10 / 1.1"
