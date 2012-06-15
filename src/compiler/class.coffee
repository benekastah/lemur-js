L = lemur
C = L.compiler

class C.Class extends C.Construct
  anon_id: 0
  
  constructor: (config={}, yy) ->
    super
    if not config.hasOwnProperty 'constructor'
      config.constructor = null
    {@name, constructor, @prototype, @statics} = config
    @name ?= new C.String "Anonymous_$#{id++}_"
    @class_constructor = constructor ? new C.Function {}, yy
    @prototype ?= new C.Object [], yy
    @statics ?= new C.Object [], yy
    
    @class_constructor.name = @name
    
  object_compile: (prefix, obj) ->
    pairs = for [prop, val] in obj.property_value_pairs
      "#{prefix}.#{prop.compile()} = #{val.compile()}"
    pairs.join ';\n  '
    
  compile: ->
    statics = object_compile @name, @statics
    proto = object_compile "#{@name}.prototype", @prototype
    """
        #{@name} = (function () {
          #{@class_constructor.compile()};
          #{statics};
          #{proto};
          return #{@name};
        })()
        """
    