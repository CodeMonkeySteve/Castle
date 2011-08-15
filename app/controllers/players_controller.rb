class PlayersController < ApplicationController

  before_filter :find_player

  def show
    render json: @player.as_json
  end

  def play
    @player.play
    render json: @player.as_json
  end

  def pause
    @player.pause
    render json: @player.as_json
  end

  def stop
    @player.stop
    render json: @player.as_json
  end

  def volume
    @player.volume =
      if %w(- +).include? params[:vol][0]
        @player.volume + params[:vol].to_i
      else
        params[:vol].to_i
      end
    render json: @player.as_json
  end

protected
  def find_player
    @player = Castle.player
  end
end
