require 'faraday'
require 'json'

module Weatherbit
  class WeatherbitApiError < StandardError; end

  class Client
    BASE_URL = "https://api.weatherbit.io/v2.0".freeze

    def initialize(api_key:)
      @api_key = api_key
      @connection = Faraday.new(url: BASE_URL)
    end

    def daily_forecast(lat:, lng:)
      get("forecast/daily", lat:, lng:)
    end

    def current_weather(lat:, lng:)
      get("current", lat:, lng:)
    end

    private

    def get(endpoint, lat:, lng:)
      response = @connection.get(endpoint) do |req|
        req.params['lat'] = lat
        req.params['lon'] = lng
        req.params['key'] = @api_key
      end

      unless response.success?
        raise WeatherbitApiError.new("API Error: #{response.status} - #{response.body}")
      end

      JSON.parse(response.body)
    end
  end
end
