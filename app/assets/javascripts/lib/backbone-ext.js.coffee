# class Backbone.Collection extends Backbone.Collection
#   @view = (name) ->
#     coll_cl = this
#     @prototype[name] = (opts) ->
#       @_viewColls[name] ?= {}
#       unless coll = @_viewColls[name]?
#         coll = @_viewColls[name] = new coll_cl
#       coll
