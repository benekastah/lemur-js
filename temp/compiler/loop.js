// Generated by CoffeeScript 1.3.3
(function() {
  var C, L,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  L = lemur;

  C = L.Compiler;

  C.Loop = (function(_super) {

    __extends(Loop, _super);

    function Loop() {
      return Loop.__super__.constructor.apply(this, arguments);
    }

    Loop.BREAK = {
      compile: function() {
        return "break";
      }
    };

    Loop.CONTINUE = {
      compile: function() {
        return "continue";
      }
    };

    return Loop;

  })(C.Construct);

  C.ForLoop = (function(_super) {

    __extends(ForLoop, _super);

    function ForLoop(_arg) {
      var condition;
      condition = _arg.condition, this.body = _arg.body;
      this.a = condition[0], this.b = condition[1], this.c = condition[2];
      ForLoop.__super__.constructor.apply(this, arguments);
    }

    ForLoop.prototype.compile = function() {
      var c_a, c_b, c_body, c_c, item;
      c_a = this.a.compile();
      c_b = this.b.compile();
      c_c = this.c.compile();
      c_body = (function() {
        var _i, _len, _ref, _results;
        _ref = this.body;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          _results.push(item.compile());
        }
        return _results;
      }).call(this);
      return "for (" + c_a + "; " + c_b + "; " + c_c + ") {\n	" + (c_body.join(';\n  ')) + ";\n}";
    };

    return ForLoop;

  })(C.Loop);

  C.ForEachLoop = (function(_super) {

    __extends(ForEachLoop, _super);

    function ForEachLoop(_arg, yy) {
      var a, b, c, i, len, vlen;
      this.collection = _arg.collection, this.body = _arg.body;
      i = C.Var.gensym("i", yy);
      vlen = C.Var.gensym("len", yy);
      len = new C.PropertyAccess([this.collection, C.Symbol("length")]);
      a = new C.Comma(C.Var.Set({
        "var": i,
        value: C.Number(0, yy)
      }), C.Var.Set({
        "var": vlen,
        value: len
      }));
      b = new C.LT([i, len]);
      c = new C.PostIncr(i);
      ForEachLoop.__super__.constructor.call(this, [a, b, c], yy);
    }

    return ForEachLoop;

  })(C.ForLoop);

  C.ForInLoop = (function(_super) {

    __extends(ForInLoop, _super);

    function ForInLoop(_arg) {
      this.property = _arg.property, this.object = _arg.object, this.body = _arg.body;
      ForInLoop.__super__.constructor.apply(this, arguments);
    }

    ForInLoop.prototype.compile = function() {
      var c_body, c_object, c_property, item;
      c_property = this.property.compile();
      c_object = this.object.compile();
      c_body = (function() {
        var _i, _len, _ref, _results;
        _ref = this.body;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          _results.push(item.compile());
        }
        return _results;
      }).call(this);
      return "for (" + c_property + " in " + c_object + ") {\n  " + (c_body.join(';\n  ')) + ";\n}";
    };

    return ForInLoop;

  })(C.Loop);

  C.WhileLoop = (function(_super) {

    __extends(WhileLoop, _super);

    function WhileLoop(_arg) {
      this.condition = _arg.condition, this.body = _arg.body;
      WhileLoop.__super__.constructor.apply(this, arguments);
    }

    WhileLoop.prototype.compile = function() {
      var c_body, c_condition, item;
      c_condition = this.condition.compile();
      c_body = (function() {
        var _i, _len, _ref, _results;
        _ref = this.body;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          _results.push(item.compile());
        }
        return _results;
      }).call(this);
      return "while (" + c_condition + ") {\n  " + (c_body.join(';\n  ')) + ";\n}";
    };

    return WhileLoop;

  })(C.Loop);

  C.DoWhileLoop = (function(_super) {

    __extends(DoWhileLoop, _super);

    function DoWhileLoop(_arg) {
      this.condition = _arg.condition, this.body = _arg.body;
      DoWhileLoop.__super__.constructor.apply(this, arguments);
    }

    DoWhileLoop.prototype.compile = function() {
      var c_body, c_condition, item;
      c_condition = this.condition.compile();
      c_body = (function() {
        var _i, _len, _ref, _results;
        _ref = this.body;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          _results.push(item.compile());
        }
        return _results;
      }).call(this);
      return "do {\n  " + (c_body.join(';\n  ')) + ";\n} while (" + c_condition + ")";
    };

    return DoWhileLoop;

  })(C.Loop);

}).call(this);
