class C.Symbol extends C.Construct
  constructor: (@name) ->
    if @name instanceof C.Symbol
      @name = @name.name
    super
    
  compile: -> C.Var.text_to_js_identifier @name
  
  error_cant_redefine: -> @error "Can't redefine var #{@name}"
  
  error_cant_set: -> @error "Can't set nonexistant var #{@name}"
  
  @gensym = (s = "sym", yy) ->
    s = s.name if s instanceof C.Symbol
    now = (+new Date()).toString 36
    rand = Math.floor(Math.random() * 1e6).toString 36
    new this "#{s}-#{rand}-#{now}", yy

  @text_to_js_identifier = (text, conversions) ->
    if (@JS_KEYWORDS.indexOf text) >= 0
      return @wrapper text

    if text.length is 0
      return @wrapper "null"

    _char_wrapper = @char_wrapper.bind this, conversions

    ((text
    .replace @WRAPPER_REGEX, @wrapper)
    .replace /^\d/, _char_wrapper)
    .replace /[^\w\$]/g, _char_wrapper
    
  @char_wrapper = (conversions={}, _char) ->
    txt = conversions[_char] ? @JS_ILLEGAL_IDENTIFIER_CHARS[_char] ? "ASCII_#{_char.charCodeAt 0}"
    @wrapper txt
    
  @wrapper = (text) ->
    "#{@WRAPPER_PREFIX}#{text}#{@WRAPPER_SUFFIX}"
    
  @WRAPPER_PREFIX = "_$"
  @WRAPPER_SUFFIX = "_"
  @WRAPPER_REGEX = /_\$[^_]+_/g
    
  @JS_KEYWORDS = [
    "break"
    "case"
    "catch"
    "char"
    "class"
    "const"
    "continue"
    "debugger"
    "default"
    "delete"
    "do"
    "else"
    "enum"
    "export"
    "extends"
    "false"
    "finally"
    "for"
    "function"
    "if"
    "implements"
    "import"
    "in"
    "instanceof"
    "interface"
    "let"
    "new"
    "null"
    "package"
    "private"
    "protected"
    "public"
    "return"
    "static"
    "switch"
    "super"
    "this"
    "throw"
    "true"
    "try"
    "typeof"
    "undefined"
    "var"
    "void"
    "while"
    "with"
    "yield"
  ]

  @JS_ILLEGAL_IDENTIFIER_CHARS =
    "~": "tilde"
    "`": "backtick"
    "!": "exclamationmark"
    "@": "at"
    "#": "pound"
    "%": "percent"
    "^": "carat"
    "&": "amperstand"
    "*": "asterisk"
    "(": "leftparen"
    ")": "rightparen"
    "-": "dash"
    "+": "plus"
    "=": "equals"
    "{": "leftcurly"
    "}": "rightcurly"
    "[": "leftsquare"
    "]": "rightsquare"
    "|": "pipe"
    "\\": "backslash"
    "\"": "doublequote"
    "'": "singlequote"
    ":": "colon"
    ";": "semicolon"
    "<": "leftangle"
    ">": "rightangle"
    ",": "comma"
    ".": "period"
    "?": "questionmark"
    "/": "forwardslash"
    " ": "space"
    "\t": "tab"
    "\n": "newline"
    "\r": "carriagereturn"



class C.Var extends C.Symbol
  constructor: ->
    super

  compile: ->
    if not @defined?
      scope = C.current_scope()
      scope.def_var this
      @defined = true
    super



class C.Var.Set extends C.Construct
  constructor: ({@_var, value, @must_exist}, yy) ->
    super
    @value = value
    @must_exist ?= true

  compile: ->
    c_var = @_var._compile()
    c_val = @value._compile()

    scope = C.find_scope_with_var @_var
    if @must_exist and not scope
      @_var.error_cant_set()
    scope?.set_var @_var, @value

    "#{c_var} = #{c_val}"