class TracksController < ApplicationController
  def create
    file = params[:file]
    @track = Track.from_file( file.path, file.content_type, file.original_filename )
    @track.tags = params[:tags].split(',').map(&:strip)  if params[:tags].present?
    CouchPotato.database.save_document! @track
    render json: @track
  end
end
