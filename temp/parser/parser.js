// Generated by CoffeeScript 1.3.3
(function() {
  var JisonParser, L, Parser,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __slice = [].slice;

  if ((typeof process !== "undefined" && process !== null ? process.title : void 0) === "node") {
    require('coffee-script');
    L = typeof lemur !== "undefined" && lemur !== null ? lemur : require('../core');
    JisonParser = (require('jison')).Parser;
    Parser = (function(_super) {

      __extends(Parser, _super);

      Parser.prototype.re = {
        lex_return: /^(return|function)/,
        "function": /^function/,
        strip_function: /^function\s*\([\w,]*\)\s*/,
        unwrap_function: /^function\s*\(\)\s*\{\s*return\s*([\s\S]*);\s*\}/,
        whitespace: /\s+/g,
        regex_special: /[\^\$\*\+\?\.\(\)\|\{\}\[\]\\\/]/g,
        comment: /^\/\*.*\*\//,
        jison_special: /\<\<\w+\>\>/
      };

      function Parser(_arg) {
        var alternatives, entry, grammar, lexer, name, operators, rule, _i, _j, _len, _len1;
        lexer = _arg.lexer, operators = _arg.operators, grammar = _arg.grammar, this.start = _arg.start;
        this.lexer = {
          rules: []
        };
        this.grammar = {};
        this.operators = [];
        if (lexer != null) {
          for (_i = 0, _len = lexer.length; _i < _len; _i++) {
            rule = lexer[_i];
            this.lex_rule.apply(this, rule);
          }
        }
        if (operators != null) {
          for (_j = 0, _len1 = operators.length; _j < _len1; _j++) {
            entry = operators[_j];
            this.operator_rule(entry);
          }
        }
        if (grammar != null) {
          for (name in grammar) {
            if (!__hasProp.call(grammar, name)) continue;
            alternatives = grammar[name];
            this.grammar_rule.apply(this, [name].concat(__slice.call(alternatives)));
          }
        }
        this.parser = new JisonParser({
          lex: this.lexer,
          operators: this.operators,
          bnf: this.grammar,
          startSymbol: this.start
        });
      }

      Parser.prototype.lex_rule = function(pattern, ret) {
        var jison_pattern, jison_ret;
        if (L.core.to_type(pattern) === 'regexp') {
          jison_pattern = pattern.source;
        } else if (!this.re.jison_special.test(pattern)) {
          jison_pattern = pattern.replace(this.re.regex_special, "\\$&");
        }
        if (!(ret != null)) {
          jison_ret = pattern;
        }
        if (L.core.to_type(ret) !== 'string') {
          ret = String(ret);
        }
        jison_ret = L.core.s_trim.call(ret);
        if (!this.re.comment.test(jison_ret)) {
          if (!this.re.lex_return.test(jison_ret)) {
            jison_ret = "return '" + jison_ret + "';";
          } else if (this.re.lex_function.test(jison_ret)) {
            jison_ret = jison_ret.replace(this.re.strip_function, '');
          }
        }
        return this.lexer.rules.push([jison_pattern, jison_ret]);
      };

      Parser.prototype.grammar_rule = function() {
        var action, alt, alternatives, jison_action, match, name, options, pattern;
        name = arguments[0], alternatives = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
        return this.grammar[name] = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = alternatives.length; _i < _len; _i++) {
            alt = alternatives[_i];
            pattern = alt[0], action = alt[1], options = alt[2];
            if (action != null) {
              action = (match = this.re.unwrap_function.exec(action)) ? match[1] : "(" + action + "())";
              jison_action = "$$ = " + action + ";";
            } else {
              jison_action = "$$ = $1;";
            }
            if (name === this.start) {
              jison_action += " return $$;";
            }
            _results.push([pattern, jison_action, options]);
          }
          return _results;
        }).call(this);
      };

      Parser.prototype.operator_rule = function() {
        var op1, ops;
        ops = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        if (ops.length === 1) {
          ops = ops[0];
        }
        if (L.core.to_type(ops) === 'string') {
          ops = ops.split(this.re.whitespace);
        }
        if (ops.length === 2) {
          op1 = ops.pop().split(this.re.whitespace);
          ops = ops.concat(op1);
        }
        return this.operators.push(ops);
      };

      return Parser;

    })(JisonParser);
    L.parser = function(config) {
      return (new Parser(config)).parser;
    };
    if (typeof exports !== "undefined" && exports !== null) {
      if (typeof module !== "undefined" && module !== null) {
        module.exports = L.parser;
      }
    }
  }

}).call(this);
