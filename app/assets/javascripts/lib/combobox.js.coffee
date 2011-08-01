(($) ->
  $.widget('ui.combobox', {
    options: 
      matchFromStart: false
      allowAnyValue: true

    _create: ->
      self = this ; input = @element ; opts = @options
      @element.data('_normalized_values', [])

      autocomplete = {
        delay: 0
        minLength: 0

        source: (request, response) ->
          term = request.term
          term = /(^| )([^ ]*)$/.exec(term)[2]  if opts.multiWord

          unless term? && term.length
            return response(
              for item in input.data('_normalized_values')
                _.extend {label: item.value}, item
            )

          term = $.ui.autocomplete.escapeRegex(request.term)
          re = new RegExp( (if opts.matchFromStart then '^' else '') + term, 'i' )
          return response(
            for item in input.data('_normalized_values')  when re.test(item.value)
              label = item.value.replace(
                /(?![^&;]+;)(?!<[^<>]*)(#{term})(?![^<>]*>)(?![^&;]+;)/gi
                "<strong>$1</strong>"
              )
              _.extend( {label: label}, item )
          )

        select: (ev, ui) ->
          input.val( ui.item.value )
          self._trigger( 'select', ev, {item: ui.item} )
          false

        change: (ev, ui) ->
          return  if ui.item?

          term = $(input).val()
          term = /(^| )([^ ]*)$/.exec(term)[2]  if opts.multiWord
          selected = (item for item in input.data('_normalized_values')  when item.value == term)[0]  if term.length

          unless selected || opts.allowAnyValue
            # remove invalid value, as it didn't match anything
            $(this).val('')
            input.data('autocomplete').term = ''
            return false

          if selected
            self._trigger( 'select', ev, {item: selected} )
          else
            self._trigger( 'change', ev, {item: {value: term}} )

          false
      }

      input.autocomplete(autocomplete).addClass('ui-widget ui-widget-content ui-corner-left')
      input.data('autocomplete')._renderItem = (ul, item) ->
        $('<li></li>')
          .data('item.autocomplete', item)
          .append('<a>' + item.label + '</a>' )
          .appendTo(ul)

      @button = $("<button type='button'>&nbsp;</button>")
        .attr('tabIndex', -1)
        .attr('title', "Show All Items")
        .insertAfter(input)
        .button({
          icons: { primary: "ui-icon-triangle-1-s" }
          text:  false
        })
        .removeClass('ui-corner-all')
        .addClass('ui-corner-right ui-button-icon')
        .click ->
          # close if already visible
          return  if input.autocomplete('widget').is(':visible' ) && input.autocomplete('close')

          # work around a bug (likely same cause as #5265)
          $(this).blur()

          # pass empty string as value to search for, displaying all results
          input.autocomplete('search', '')
          input.focus()

    values: (values) ->
      return @element.data('values')  unless values?
      @element.data('values', values)

      if _.isArray(values)
        values = _.map( values, (val) ->
          if (typeof(val) == 'object')  then val  else { value: val.toString() }
        )
      else
        values = _.map( values, (mval, val) -> { value: val, model_value: mval } )

      @element.data('_normalized_values', values)

    destroy: ->
      @button.remove()
      $.Widget.prototype.destroy.call( this )
  })
)(jQuery)
