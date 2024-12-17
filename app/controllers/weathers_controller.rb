class WeathersController < ApplicationController
  before_action :authenticate_user!

  def index
    @weather_data = {
      city: "Paris",
      date: "December 16, 2024",
      temperature: "25°C",
      feelsLike: "27°C",
      isDay: false,
      condition: "cloudy",
      forecast: [
        { day: "Monday", condition: "cloudy", min: "12°C", max: "20°C" },
        { day: "Tuesday", condition: "rainy", min: "10°C", max: "18°C" },
        { day: "Wednesday", condition: "sunny", min: "14°C", max: "22°C" },
        { day: "Thursday", condition: "sunny", min: "14°C", max: "22°C" },
        { day: "Friday", condition: "sunny", min: "14°C", max: "22°C" }
      ]
    }
  end
end
