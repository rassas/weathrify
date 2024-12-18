module Services
  module Weather
    class TemperatureService
      class FetchTemperatureError < StandardError; end

      def initialize(city_list)
        @city_list = city_list
      end

      def call
        temperatures = city_list.map do |city|
          temperature_for_city(city)
        end.compact

        if temperatures.blank? || temperatures.size < city_list.size
          raise FetchTemperatureError.new("Could not fetch temperatures for all cities")
        end

        temperatures.sum / temperatures.size.to_f
      end

      private

      attr_reader :city_list

      def temperature_for_city(city)
        client.current_weather(city: city)["data"].first["temp"]
      end

      def client
        @client ||= Weatherbit::Client.new(api_key: Rails.application.credentials.weatherbit_apikey)
      end
    end
  end
end
