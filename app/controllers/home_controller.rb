class HomeController < ApplicationController
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
    require 'Oembed'
    begin
      OEmbed::Providers::Youtube.get(url)
    rescue
    end
  end

  def is_youtube_url?( input )
    true if input.match( /^(http(s)?:\/\/)?(www+\.)?youtube\.com\/(.*?)/)
  end

  def prepend_http_if_missing( url )
    "http://#{url.gsub(/^http(s)?:\/\//,'')}"
  end

  def generate_url_from_vid( vid )
    "http://www.youtube.com/watch?v=#{vid}"
  end



  # @Routes
  def index
    # do nothing
  end

  def search
    # @DZ: Find out if we got a url or a youtube query
    response = []

    if is_youtube_url?(params['q'])
      full_url = prepend_http_if_missing(params['q'])
      response << render_embedded_response(full_url).html
    else
      client, youtube = get_youtube_client
      begin
        client_response = client.execute!(
            :api_method => youtube.search.list,
            :parameters => {
                :part => 'snippet',
                :q => params['q'],
                :type => params['type'],
                # :order => 'viewCount',
                :maxResults => 25
            }
        )
      rescue Google::APIClient::TransmissionError => e
        puts e.result.body
      end

      json_hash = JSON.parse(client_response.response.body)
      json_hash['items'].each do |item|
        full_url = generate_url_from_vid(item['id']['videoId'])
        response << render_embedded_response(full_url).html
      end
    end

    render json: response
  end
end