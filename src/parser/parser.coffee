if process?.title is "node"
  require 'coffee-script'
  L = require '../core'
  JisonParser = (require 'jison').Parser

  class Parser extends JisonParser
    re: {
      lex_return: /^(return|function)/
      function: /^function/
      strip_function: /^function\s*\([\w,]*\)\s*/
      unwrap_function: /^function\s*\(\)\s*\{\s*return\s*([\s\S]*);\s*\}/
      whitespace: /\s+/g
      regex_special: /[\^\$\*\+\?\.\(\)\|\{\}\[\]\\\/]/g
      comment: /^\/\*.*\*\//
      jison_special: /\<\<\w+\>\>/
    }
  
    constructor: ({lexer, operators, grammar, @start}) ->
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
    
      @parser = new JisonParser
        lex: @lexer
        operators: @operators
        bnf: @grammar
        startSymbol: @start
  
    lex_rule: (pattern, ret) ->
      if L.core.to_type(pattern) is 'regexp'
        jison_pattern = pattern.source
      else if not @re.jison_special.test pattern
        jison_pattern = pattern.replace @re.regex_special, "\\$&"
    
      if not ret?
        jison_ret = pattern
      
      if L.core.to_type(ret) isnt 'string'
        ret = String ret
      jison_ret = L.core.s_trim.call ret
    
      unless @re.comment.test jison_ret
        if not @re.lex_return.test jison_ret
          jison_ret = "return '#{jison_ret}';"
        else if @re.lex_function.test jison_ret
          jison_ret = jison_ret.replace @re.strip_function, ''
      
      @lexer.rules.push [jison_pattern, jison_ret]
    
    grammar_rule: (name, alternatives...) ->
      @grammar[name] = for alt in alternatives
        [pattern, action, options] = alt
      
        if action?
          action = if (match = @re.unwrap_function.exec action) then match[1] else "(#{action}())"
          jison_action = "$$ = #{action};"
        else
          jison_action = "$$ = $1;"
        
        if name is @start
          jison_action += " return $$;"
        [pattern, jison_action, options]
    
    operator_rule: (ops...) ->
      if ops.length is 1
        ops = ops[0]
    
      if L.core.to_type(ops) is 'string'
        ops = ops.split @re.whitespace
      
      if ops.length is 2
        op1 = ops.pop().split @re.whitespace
        ops = ops.concat op1
      
      @operators.push ops
    
  L.parser = (config) ->
    (new Parser config).parser
  
  if exports? then module?.exports = L.parser
  