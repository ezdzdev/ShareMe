class HomeController < ApplicationController
  def is_youtube_url?( input )
    true if input.match( /^(http(s)?:\/\/)?(www+\.)?youtube\.com\/(.*?)/)
  end

  def prepend_http_if_missing( url )
    "http://#{url.gsub(/^http(s)?:\/\//,'')}"
  end

  # @Routes
  def index
    # do nothing
  end

  def search
    results = []
    status = 'success'
    message = ''

    begin
      # @DZ: Find out if we got a url or a youtube query
      if is_youtube_url?(params['q'])
        full_url = prepend_http_if_missing(params['q'])
        results << render_embedded_response(full_url).html
      else
        client, youtube = get_youtube_client
        client_response = client.execute!(
            :api_method => youtube.search.list,
            :parameters => {
                :part => 'snippet',
                :q => params['q'],
                :type => params['type'],
                :maxResults => 5
                # :maxResults => params['url'] == '/' ? 5 : 1
                # :order => 'viewCount',
            }
        )
        json_hash = JSON.parse(client_response.response.body)
        json_hash['items'].each do |item|
          results << render_embedded_from_vid(item['id']['videoId']).html
        end
      end
    rescue Google::APIClient::TransmissionError => e
      status = 'error'
      message = e.message
    rescue Exception => e
      status = 'error'
      message = e.message
    end

    render json: {
        :results => results,
        :status => status,
        :message => message
    }
  end
end