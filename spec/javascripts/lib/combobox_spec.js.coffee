describe "ui.combobox", ->
  beforeEach ->
    @el = $('<input/>').combobox()

  describe "with an array of values", ->
    beforeEach ->
      @el.combobox('values', ['one', 'two', 'three'])

    it "normalizes values", ->
      expect(@el.data('_normalized_values')[1]).toEqual({value: 'two'})

  describe "with an object with label/values", ->
    beforeEach ->
      @el.combobox('values', {'one': 10, 'two': 20, 'three': 30})

    it "normalizes values", ->
      expect(@el.data('_normalized_values')[1]).toEqual({value: 'two', model_value: 20})

    it "#change (new value)", ->
      item = null ; val = 'forty-two'
      @el.bind( 'comboboxchange', (ev, ui) -> item = ui.item  )
      @el.val(val).blur()
      waitsFor -> item?
      runs -> expect(item.value).toEqual(val)

    it "#change (existing value)", ->
      item = null ; val = _.last( @el.data('_normalized_values') )
      @el.bind( 'comboboxselect', (ev, ui) -> item = ui.item )
      @el.val(val.value).blur()
      waitsFor -> item?
      runs -> expect(item).toEqual(val)

    it "#select", ->
      val = _.last( @el.data('_normalized_values') )
      combobox = @el.data('combobox')
      button = combobox.button

      item = null
      @el.bind( 'comboboxselect', (ev, ui) -> item = ui.item )

      choices = null
      runs -> button.click()
      waitsFor -> (choices = $('ul.ui-autocomplete.ui-menu[role=listbox]')).length
      runs ->
        choices.find('li:last a').mouseenter().click()
      runs ->
        expect(item.value).toEqual(val.value)
        expect(item.model_value).toEqual(val.model_value)

  describe "with multiWord", ->
    beforeEach ->
      @el.combobox(multiWord: true)
      @el.combobox('values', {'one': 10, 'two': 20, 'three': 30})

    it "#source (empty)", ->
      #@el.
    