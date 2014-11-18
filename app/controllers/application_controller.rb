class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # @DZ: move this into heroku ENV variables
  DEVELOPER_KEY = 'AIzaSyBjLnm6IwLOeLFIsPjktBFbccPlYVPdBIw'
  APPLICATION_NAME = 'ShareMe'
  YOUTUBE_API_SERVICE_NAME = 'youtube'
  YOUTUBE_API_VERSION = 'v3'

  def get_youtube_client
    require 'google/api_client'
    client = Google::APIClient.new(
        :key => DEVELOPER_KEY,
        :authorization => nil,
        :application_name => APPLICATION_NAME,
        :application_version => '1.0.0'
    )
    youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)

    [client, youtube]
  end

  def render_embedded_response( url )
    require 'oembed'
    begin
      OEmbed::Providers::Youtube.get(url)
    rescue
      nil
    end
  end

  def generate_url_from_vid( vid )
    "http://www.youtube.com/watch?v=#{vid}"
  end

  def get_vid_from_url( url )
    if url.present?
      url.match(/\/([a-zA-Z0-9_-]{11})\?/)
      $1
    else
      nil
    end
  end

  def render_embedded_from_vid( vid )
    url = generate_url_from_vid(vid)
    render_embedded_response(url)
  end
end
