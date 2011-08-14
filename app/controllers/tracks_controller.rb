class TracksController < ApplicationController
  def show
    @track = Track.find! params[:id]
    render json: @track
  end

  def create
    file = params[:file]
    @track = Track.from_file( file.path, file.content_type )
    if @track.new_record?
      @track.save!
      @track.put_attachment(file.original_filename, file.open, :content_type => file.content_type)
    end
    render json: @track
  end

  def update
    @track = Track.find! params[:id]
    track = params[:track]
    track[:tags] = track[:tags].split(',').map(&:strip)  if track.present?
    if @track.update_attributes track
      render json: @track
    else
      render text: @track.errors.full_messages, :status => 500
    end
  end
end
