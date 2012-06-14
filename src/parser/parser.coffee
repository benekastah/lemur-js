require 'coffee-script'
L = require '../core'
JisonParser = (require 'jison').Parser

class Parser extends JisonParser
  re: {
    lex_return: /^(return|function)/
    function: /^function/
    strip_function: /^function\s*\([\w,]*\)\s*/
    unwrap_function: /^function\s*\(\)\s*\{\s*return\s*([\s\S]*);\s*\}/
    whitespace: /\s+/
  }
  
  constructor: ({lexer, operators, grammar, start}) ->
    @lexer = { rules: [] }
    @grammar = {}
    @operators = []
    
    if lexer?
      for rule in lexer
        @lex_rule rule...
    
    if operators?
      for entry in operators
        @operator_rule entry
    
    if grammar?
      for own name, alternatives of grammar
        @grammar_rule name, alternatives...
        
    lexer = @lexer; delete @lexer
    operators = @operators; delete @operators
    grammar = @grammar; delete @grammar
    
    super
      lex: lexer
      operators: operators
      bnf: grammar
      startSymbol: start
  
  lex_rule: (pattern, ret) ->
    if L.core.to_type(pattern) is 'regexp'
      jison_pattern = pattern.source
    else
      jison_pattern = pattern
    
    if not ret?
      jison_ret = pattern
    else
      if !L.core.to_type(ret) is 'string'
        ret = ret.toString()
      jison_ret = L.core.s_trim ret
      
      if !@re.lex_return.test jison_ret
        jison_ret = "return '#{ret}';"
      else if @re.lex_function.test jison_ret
        jison_ret = jison_ret.replace @re.strip_function, ''
      
    @lexer.rules.push [jison_pattern, jison_ret]
    
  grammar_rule: (name, alternatives...) ->
    @grammar[name] = for alt in alternatives
      [pattern, action, options] = alt
      if action?
        action = if (match = @re.unwrap_function.exec action) then match[1] else "(#{action}())"
        [pattern, "$$ = #{action};", options]
      else
        [pattern, "$$ = $1;", options]
    
  operator_rule: (ops...) ->
    if ops.length is 1
      ops = ops[0]
    
    if L.core.to_type(ops) is 'string'
      ops = ops.split @re.whitespace
      
    if ops.length is 2
      op1 = ops.pop().split @re.whitespace
      ops = ops.concat op1
      
    @operators.push ops
    
module.exports = Parser