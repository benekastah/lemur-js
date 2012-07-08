// Generated by CoffeeScript 1.3.3
(function() {
  var C, L,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  L = lemur;

  C = L.Compiler;

  C.Construct = (function() {

    function Construct(value, yy_or_node_or_num) {
      var _ref;
      this.value = value;
      if (yy_or_node_or_num instanceof Construct) {
        this.transfer_node = yy_or_node_or_num;
        this.yy = yy_or_node_or_num.yy;
      } else if ((L.core.to_type(yy_or_node_or_num)) === "number") {
        this.yy = {
          lexer: {
            yylineno: yy_or_node_or_num
          }
        };
      } else {
        this.yy = yy_or_node_or_num;
      }
      this.line_number = (_ref = this.yy) != null ? _ref.lexer.yylineno : void 0;
    }

    Construct.prototype.compile = function() {
      if (this.value != null) {
        return "" + this.value;
      } else {
        return "null";
      }
    };

    Construct.prototype.error = function(message) {
      var filename, location, type;
      filename = C.current_filename;
      location = "";
      type = "";
      if (filename != null) {
        location += " in " + filename;
      }
      if (this.line_number != null) {
        location += " at line " + this.line_number;
      }
      if (this.constructor.name != null) {
        type = "" + this.constructor.name;
      }
      throw "" + type + "Error" + location + ": " + message;
    };

    Construct.prototype.should_return = function() {
      var Construct, ReturnedConstruct;
      Construct = function() {};
      Construct.prototype = this;
      ReturnedConstruct = (function(_super) {

        __extends(ReturnedConstruct, _super);

        function ReturnedConstruct() {
          return ReturnedConstruct.__super__.constructor.apply(this, arguments);
        }

        ReturnedConstruct.prototype.compile = function() {
          return "return " + ReturnedConstruct.__super__.compile.apply(this, arguments);
        };

        return ReturnedConstruct;

      })(Construct);
      return new ReturnedConstruct();
    };

    return Construct;

  })();

}).call(this);
