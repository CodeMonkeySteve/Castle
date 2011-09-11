class App.Model extends Backbone.CouchDB.Model
  initialize: ->
    return unless @defaults?
    attrs = owl.deepCopy(@defaults)
    jQuery.extend( true, attrs, @attributes )
    @attributes = attrs

  set: (attrs, opts) ->
    return this  unless attrs? && _.keys(attrs).length

    out_attrs = {}
    for key, val of attrs
      path = key.split('.')
      if path.length == 1
        out_attrs[key] = val
      else
        name = path.shift()
        obj = out_attrs[name] = owl.deepCopy(@attributes[name]) || {}
        last = path.pop()

        obj = obj[name] = (obj[name] || {})  for name in path
        obj[last] = val
    super(out_attrs, opts)

  get: (key) ->
    val = @attributes
    val &&= val[name]  for name in key.split('.')
    val

  save: (attrs, opts) ->
    @set(attrs)
    return false  if @validate && !Model.__super__._performValidation.call(this, attrs, opts)
    super(null, opts)

  _performValidation: (attrs, opts) ->
    super(attrs, opts)
    true
