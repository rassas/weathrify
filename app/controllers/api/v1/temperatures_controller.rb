module Api
  module V1
    class TemperaturesController < ::Api::V1::ApplicationController
      before_action :authenticate_user

      # Expected format: /api/v1/temperatures?cities=London,Paris,Tokyo
      def index
        return render json: { error: "No cities provided" }, status: :bad_request if city_list.blank?

        average_temp = Services::Weather::TemperatureService.new(city_list).call
        render json: { average_temperature: average_temp.round(2), cities: city_list }
      rescue Services::Weather::TemperatureService::FetchTemperatureError => e
        render json: { error: e.message }, status: :unprocessable_entity
      rescue Weatherbit::WeatherbitApiError
        render json: { error: "Something went wrong! You may reached the limit of 50 calls per day!" }, status: :unprocessable_entity
      end

      private

      def city_list
        @city_list ||= params[:cities]&.split(",")&.map(&:strip)
      end
    end
  end
end
