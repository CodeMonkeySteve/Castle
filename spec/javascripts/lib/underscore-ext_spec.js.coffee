describe "Underscore", ->
  beforeEach ->
    @obj = {foo: 42}

  describe "isBlank", ->
    it "true", ->
      expect(_.isBlank(@something_undefined)).toBeTruthy()
      expect(_.isBlank(null)).toBeTruthy()
      expect(_.isBlank(false)).toBeTruthy()
      expect(_.isBlank('')).toBeTruthy()
      expect(_.isBlank([])).toBeTruthy()
      expect(_.isBlank({})).toBeTruthy()
      expect(_.isBlank(@obj.bar)).toBeTruthy()

    it "false", ->
      expect(_.isBlank(true)).toBeFalsy()
      expect(_.isBlank(0)).toBeFalsy()
      expect(_.isBlank(42)).toBeFalsy()
      expect(_.isBlank(42.42)).toBeFalsy()
      expect(_.isBlank('foo')).toBeFalsy()
      expect(_.isBlank([1,2,3])).toBeFalsy()
      expect(_.isBlank(@obj)).toBeFalsy()
      expect(_.isBlank(@obj.foo)).toBeFalsy()
      expect(_.isBlank(new Date)).toBeFalsy()

  it "compact", ->
    expect( _.compact(foo: 42, bar: null) ).toEqual( foo: 42 )

  it "except", ->
    src = { foo: 42, bar: 69, baaz: 123 }
    expect( _.except(src, 'bar') ).toEqual( foo: 42, baaz: 123 )

  describe "walk", ->
    beforeEach ->
      @iteratorSpy = jasmine.createSpy()

    it "with null object", ->
      _.walk(null, @iteratorSpy)
      expect(@iteratorSpy).toHaveBeenCalledWith('', null)

    it "with undefined object", ->
      _.walk(undefined, @iteratorSpy)
      expect(@iteratorSpy).toHaveBeenCalledWith('', undefined)

    it "with primitive object", ->
      _.walk(1, @iteratorSpy)
      expect(@iteratorSpy).toHaveBeenCalledWith('', 1)

    it "with flat object", ->
      _.walk({a: 1, b: 2}, @iteratorSpy)
      expect(@iteratorSpy.calls[0].args).toEqual(['a', 1])
      expect(@iteratorSpy.calls[1].args).toEqual(['b', 2])

    it "with nested object", ->
      _.walk({a: {b: 1}, c: 2}, @iteratorSpy)
      expect(@iteratorSpy.calls[0].args).toEqual(['a.b', 1])
      expect(@iteratorSpy.calls[1].args).toEqual(['c', 2])
