// Generated by CoffeeScript 1.3.3
(function() {
  var C, L;

  L = lemur;

  C = L.Compiler;

  C.Scope = (function() {

    function Scope() {
      this.last_scope = Scope.current_scope();
      this.vars = [];
      Scope.push_scope(this);
    }

    Scope.prototype.def_var = function(_var) {
      var v, _i, _len, _ref;
      _ref = this.vars;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        v = _ref[_i];
        if (v.name === _var.name) {
          _var.error_cant_redefine();
        }
      }
      return this.vars.push(_var);
    };

    Scope.prototype.var_defined = function(_var) {
      var found, v, _i, _len, _ref;
      _ref = this.vars;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        v = _ref[_i];
        if (v.name === _var.name) {
          found = true;
          break;
        }
      }
      return found || false;
    };

    Scope.prototype.set_var = function(_var) {
      if (!this.var_defined(_var)) {
        return _var.error_cant_set();
      }
    };

    Scope.new_scope = function() {
      return this.push_scope(new C.Scope());
    };

    Scope.push_scope = function(scope) {
      this.stack.push(scope);
      return scope;
    };

    Scope.pop_scope = function() {
      return this.stack.pop();
    };

    Scope.current_scope = function() {
      return this.stack[this.stack.length - 1];
    };

    Scope.stack = [];

    Scope.global_scope = new Scope();

    Scope.find_scope_with_var = function(_var) {
      var scope, _i, _len, _ref;
      _ref = this.stack;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        scope = _ref[_i];
        if (scope.var_defined(_var)) {
          break;
        }
      }
      return scope;
    };

    return Scope;

  })();

}).call(this);
