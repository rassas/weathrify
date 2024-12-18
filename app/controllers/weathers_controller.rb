class WeathersController < ApplicationController
  before_action :authenticate_user!

  def index
    @weather_data = Services::Weather::WeatherService.new(lat: lat_param, lng: lng_param).call
  rescue Weatherbit::WeatherbitApiError
    render :index, flash: { error: "Something went wrong! You may reached the limit of 50 calls per day!" }
  end

  private

  def lat_param
    params[:lat] || "48.8575"
  end

  def lng_param
    params[:lng] || "2.3514"
  end
end
