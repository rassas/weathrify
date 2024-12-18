module Services
  module Weather
    class WeatherService
      def initialize(lat:, lng:)
        @lat = lat
        @lng = lng
      end

      def call
        {
          city: city_name,
          date: Date.current,
          temperature: "#{temperature}°C",
          feelsLike: "#{feels_like}°C",
          isDay: is_day,
          forecast: forecast
        }
      end

      private

      attr_reader :lat, :lng

      def client
        @client ||= Weatherbit::Client.new(api_key: Rails.application.credentials.weatherbit_apikey )
      end

      def current_weather
        @current_weather ||= client.current_weather(lat: lat, lng: lng)["data"].first
      end

      def daily_forecast
        @daily_forecast ||= client.daily_forecast(lat: lat, lng: lng)
      end

      def city_name
        current_weather['city_name']
      end

      def temperature
        current_weather['temp'].round
      end

      def feels_like
        current_weather['app_temp'].round
      end

      def is_day
        current_weather['pod'] == 'd'
      end

      def forecast
        forecast_data = daily_forecast['data'][0..4] || []  # Get the next 5 days
        forecast_data.map do |day|
          {
            day: format_day_name(day['valid_date']),
            date: day['valid_date'],
            temperature: "#{day['temp'].round}°C",
            min: "#{day['min_temp'].round}°C",
            max: "#{day['max_temp'].round}°C"
          }
        end
      end

      # Format the day name (e.g. "Monday") from the date
      def format_day_name(date_str)
        Date.parse(date_str).strftime("%A")
      end
    end
  end
end
