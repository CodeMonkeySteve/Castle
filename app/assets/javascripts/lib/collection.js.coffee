class App.Collection extends Backbone.CouchDB.Collection
  initialize: (models, opts)->
    noSync = !(opts?.sync? && opts.sync)
    @_db_changes_enabled = true  if noSync
    super()
    @stop_changes()  if noSync
