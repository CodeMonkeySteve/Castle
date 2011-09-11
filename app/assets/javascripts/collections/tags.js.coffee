class App.Collections.Tags extends App.Collection
  model: Tag
  url: 'Tag'

  forTrack: (id) ->
    model = _.detect @models, (model) -> model.attributes.target_id == id
    model && model.attributes.tags

  tagTrack: (id, tags) ->
    track = App.player.playlist?.get(id)
    tag = _.detect( @models, (model) -> model.attributes.target_id == id )

    opts = {}
    opts.success = (-> track.change())  if track?

    if tag?
      tags = _.compact( _.extend( {}, tag.get('tags'), tags ) )
      if _.isEmpty(tags)
        tag.destroy( opts )
        r = App.player.playlist?.get(id).userRating()
      else
        tag.save( {tags: tags}, opts )
    else
      tags = _.compact( tags )
      unless _.isEmpty(tags)
        tag = @_add(user_id: App.user.id, target_id: id, tags: tags)
        tag.save(null, opts)
    tag
