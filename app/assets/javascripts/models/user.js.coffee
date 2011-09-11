class @User extends App.Model
  tags: (success, opts) ->
    return @_tags  if @_tags
    @_tags = new App.Collections.Tags

    opts ?= {}
    _.extend opts, startkey: [@id], endkey: [@id, {}], reduce: false,  include_docs: true, success: (resp) =>
      @_tags.reset(row.doc for row in resp.rows)
      success(@_tags)
    Backbone.couch_connector.helpers.make_db().view 'Tag/by_user_id_and_target_id', opts
    @_tags