require "faraday"
require "json"

module Weatherbit
  class WeatherbitApiError < StandardError; end
  class ArgumentError < WeatherbitApiError; end

  class Client
    BASE_URL = "https://api.weatherbit.io/v2.0".freeze
    DAILY_FORECAST_PATH = "forecast/daily".freeze
    CURRENT_WEATHER_PATH = "current".freeze

    def initialize(api_key:)
      @api_key = api_key
      @connection = Faraday.new(url: BASE_URL)
    end

    # Accept either city or lat/lng
    # Examples:
    # daily_forecast(city: "London")
    # daily_forecast(lat: 51.5072, lng: 0.1276)
    def daily_forecast(lat: nil, lng: nil, city: nil)
      validate_location_args(lat, lng, city)
      get(DAILY_FORECAST_PATH, lat: lat, lng: lng, city: city)
    end

    def current_weather(lat: nil, lng: nil, city: nil)
      validate_location_args(lat, lng, city)
      get(CURRENT_WEATHER_PATH, lat: lat, lng: lng, city: city)
    end

    private

    def get(endpoint, lat: nil, lng: nil, city: nil)
      response = @connection.get(endpoint) do |req|
        if lat && lng
          req.params["lat"] = lat
          req.params["lon"] = lng
        else
          req.params["city"] = city
        end
        req.params["key"] = @api_key
      end

      unless response.success?
        raise WeatherbitApiError, "API Error: #{response.status} - #{response.body}"
      end

      JSON.parse(response.body)
    end

    def validate_location_args(lat, lng, city)
      # Ensure we have city or lat/lng pair.
      # If you provide both of them, we will use the lat, lng
      if city.nil? && (lat.nil? || lng.nil?)
        raise ArgumentError, "You must provide either city or both lat and lng."
      end
    end
  end
end
