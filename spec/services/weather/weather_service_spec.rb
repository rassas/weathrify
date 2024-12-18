require "rails_helper"

RSpec.describe Services::Weather::WeatherService, type: :service do
  let(:lat) { 40.7128 }
  let(:lng) { -74.0060 }

  let(:current_weather_response) do
    {
      "data" => [
        {
          "city_name" => "Paris",
          "temp" => 7.2,
          "app_temp" => 5.8,
          "pod" => "d"
        }
      ]
    }
  end

  let(:daily_forecast_response) do
    {
      "data" => [
        { "valid_date" => Date.current.to_s, "temp" => 8.4, "min_temp" => 4.3, "max_temp" => 10.5 },
        { "valid_date" => (Date.current + 1).to_s, "temp" => 9.1, "min_temp" => 5.0, "max_temp" => 11.0 },
        { "valid_date" => (Date.current + 2).to_s, "temp" => 6.8, "min_temp" => 3.0, "max_temp" => 9.2 },
        { "valid_date" => (Date.current + 3).to_s, "temp" => 7.5, "min_temp" => 4.0, "max_temp" => 10.0 },
        { "valid_date" => (Date.current + 4).to_s, "temp" => 8.0, "min_temp" => 4.5, "max_temp" => 9.8 },
        { "valid_date" => (Date.current + 5).to_s, "temp" => 8.5, "min_temp" => 5.1, "max_temp" => 11.2 }
      ]
    }
  end

  let(:mock_client) { instance_double(Weatherbit::Client) }

  before do
    # Stub the API key
    allow(Rails.application.credentials).to receive(:weatherbit_apikey).and_return("test_api_key")

    # Stub the client calls
    allow(Weatherbit::Client).to receive(:new).and_return(mock_client)
    allow(mock_client).to receive(:current_weather).with(lat: lat, lng: lng).and_return(current_weather_response)
    allow(mock_client).to receive(:daily_forecast).with(lat: lat, lng: lng).and_return(daily_forecast_response)
  end

  subject(:service_call) { described_class.new(lat: lat, lng: lng).call }

  it "returns a hash with city, date, temperature, feelsLike, isDay, and forecast" do
    expect(service_call).to be_a(Hash)

    expect(service_call[:city]).to eq("Paris")
    expect(service_call[:date]).to eq(Date.current)
    expect(service_call[:temperature]).to eq("7°C")
    expect(service_call[:feelsLike]).to eq("6°C")
    expect(service_call[:isDay]).to be true

    # Forecast should have 5 days
    expect(service_call[:forecast].size).to eq(5)
    service_call[:forecast].each do |day|
      expect(day).to have_key(:day)
      expect(day).to have_key(:date)
      expect(day).to have_key(:temperature)
      expect(day).to have_key(:min)
      expect(day).to have_key(:max)
    end

    # Check formatting of a single forecast day
    first_forecast_day = service_call[:forecast].first
    expect(first_forecast_day[:day]).to eq(Date.current.strftime("%A"))
    expect(first_forecast_day[:date]).to eq(Date.current.to_s)
    expect(first_forecast_day[:temperature]).to eq("8°C")
    expect(first_forecast_day[:min]).to eq("4°C")
    expect(first_forecast_day[:max]).to eq("11°C")
  end
end
