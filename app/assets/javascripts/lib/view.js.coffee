root = exports ? window
class App.View extends Backbone.View
  updateModel: (ev, ui) ->
    el = ev.currentTarget ; attr = {}
    if ui && (ui instanceof Date)
      attr[el.name] = ui
    else
      val = (
        if ui && ui.item
          if (ui.item.model_value != undefined)
            ui.item.model_value
          else
            ui.item.value
        else
          el.value
      )
      attr[el.name] = if _.isBlank(val)  then null  else val
    @model.set(attr)
