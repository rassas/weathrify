require 'rails_helper'

RSpec.describe "Api::V1::Temperatures", type: :system do
  let(:api_key) { "test_api_key" }
  let(:cities) { "London,Paris,Tokyo" }
  let(:url) { "/api/v1/temperatures?cities=#{cities}" }

  before do
    allow_any_instance_of(Api::V1::TemperaturesController).to receive(:authenticate_user).and_return(true)
    allow(Rails.application.credentials).to receive(:weatherbit_apikey).and_return(api_key)
  end

  context "when cities parameter is provided and all temperatures are fetched successfully" do
    let(:average_temperature) { 15.0 }

    before do
      allow_any_instance_of(Services::Weather::TemperatureService).to receive(:call).and_return(average_temperature)
    end

    it "returns the average temperature and city list" do
      get url
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["average_temperature"]).to eq(average_temperature)
      expect(json["cities"]).to eq([ "London", "Paris", "Tokyo" ])
    end
  end

  context "when no cities are provided" do
    let(:url) { "/api/v1/temperatures" }

    it "returns a bad request error" do
      get url
      expect(response).to have_http_status(:bad_request)
      json = JSON.parse(response.body)
      expect(json["errors"]).to eq([ "No cities provided" ])
    end
  end

  context "when the TemperatureService fails to fetch all temperatures" do
    before do
      allow_any_instance_of(Services::Weather::TemperatureService).to receive(:call)
        .and_raise(Services::Weather::TemperatureService::FetchTemperatureError, "Could not fetch temperatures for all cities")
    end

    it "returns an error message from the service" do
      get url
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to eq([ "Could not fetch temperatures for all cities" ])
    end
  end

  context "when the Weatherbit client raises a WeatherbitApiError" do
    before do
      allow_any_instance_of(Services::Weather::TemperatureService).to receive(:call)
        .and_raise(Weatherbit::WeatherbitApiError.new("API Error"))
    end

    it "returns the fallback error message" do
      get url
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["errors"]).to eq([ "Something went wrong! You may reached the limit of 50 calls per day!" ])
    end
  end
end
