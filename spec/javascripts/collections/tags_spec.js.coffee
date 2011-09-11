describe "Tags", ->
  describe "#tagTrack", ->
    beforeEach ->
      App.user = @user = new User(_id: 'user')
      @tags = new App.Collections.Tags

    it "add", ->
      @tags.tagTrack 'track', { good: 1 }
      expect()

    it "change", ->
      @tags.tagTrack 'track', { good: 1 }
      @tags.tagTrack 'track', { good: 0 }

    it "remove", ->
