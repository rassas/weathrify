class CitiesController < ApplicationController
  before_action :authenticate_user!

  def toggle_favorite
    @city = current_user.cities.find_by(lat: city_params[:lat], lng: city_params[:lng])

    if @city.present?
      @city.destroy
      render json: { message: "removed from favory with success" }
    else
      current_user.cities.create!(city_params)
      render json: { message: "Added to favorite" }
    end
  end

  private

  def city_params
    params.permit(:lat, :lng, :name)
  end
end
