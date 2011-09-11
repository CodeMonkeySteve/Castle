_._isNumberStringRegExp = new RegExp('^[-+]?[0-9]*\.?[0-9]+$')

_.mixin(
  isDefined : (obj) -> !_.isUndefined(obj)
  isObject  : (obj) -> typeof(obj) is 'object'
  isBlank   : (obj) ->
    return true  if !obj? || (obj == false)
    return false  if (obj == true) || _.isNumber(obj) || (obj instanceof Date)
    return obj.isBlank()  if _.isFunction(obj.isBlank)
    return !obj.isPresent()  if _.isFunction(obj.isPresent)
    return (obj.length() == 0)  if _.isFunction(obj.length)
    return (obj.length == 0)  if obj.length?
    _.isEmpty(obj)

  isPresent : (obj) -> !_.isBlank(obj)

  isNumberString : (obj) -> _.isString(obj) && _._isNumberStringRegExp.test(obj)

  _origCompact : _.compact
  compact : (objs) ->
    return _origCompact(objs)  if _.isArray(objs)
    res = {}
    res[k] = v  for k, v of objs  when v?
    res

  except : (obj, props...) ->
    obj = owl.deepCopy(obj)
    delete obj[prop]  for prop in props
    obj

  walk: (obj, iterator, path = '') ->
    if !_.isNull(obj) and _.isObject(obj)
      path = path + "." unless path is ''
      _.walk( value, iterator, path + attr ) for attr, value of obj
    else
      iterator( path , obj )
)
