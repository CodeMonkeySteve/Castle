class TracksController < ApplicationController
  def create
    file = params[:file]
    @track = Track.from_file( file.path, file.content_type )
    if @track.new_record?
      @track.save!
      @track.put_attachment(file.original_filename, file.open, content_type: file.content_type)
    end
    render json: @track
  end
end
