require 'rails_helper'

RSpec.describe Weatherbit::Client do
  let(:api_key) { "test_api_key" }
  let(:lat) { 40.7128 }
  let(:lng) { -74.0060 }
  let(:city) { "Paris" }
  let(:client) { described_class.new(api_key: api_key) }
  let(:base_url) { Weatherbit::Client::BASE_URL }

  describe "#daily_forecast" do
    let(:path) { Weatherbit::Client::DAILY_FORECAST_PATH }
    context "with lat/lng parameters" do
      let(:url) { "#{base_url}/#{path}?lat=#{lat}&lon=#{lng}&key=#{api_key}" }

      context "when the response is successful" do
        let(:response_body) do
          {
            "data" => [
              { "valid_date" => "2024-12-18", "temp" => 5.0 },
              { "valid_date" => "2024-12-19", "temp" => 6.5 }
            ],
            "city_name" => "Paris"
          }.to_json
        end

        before do
          stub_request(:get, url).to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })
        end

        it "returns parsed JSON of the forecast data" do
          result = client.daily_forecast(lat: lat, lng: lng)
          expect(result["data"]).to be_an(Array)
          expect(result["data"].size).to eq(2)
          expect(result["data"].first["valid_date"]).to eq("2024-12-18")
          expect(result["data"].first["temp"]).to eq(5.0)
        end
      end

      context "when the response is an error" do
        before do
          stub_request(:get, url).to_return(status: 500, body: { error: "Internal Server Error" }.to_json)
        end

        it "raises a WeatherbitApiError" do
          expect {
            client.daily_forecast(lat: lat, lng: lng)
          }.to raise_error(Weatherbit::WeatherbitApiError, /API Error: 500/)
        end
      end
    end

    context "with city parameter" do
      let(:url) { "#{base_url}/#{path}?city=#{URI.encode_www_form_component(city)}&key=#{api_key}" }

      context "when the response is successful" do
        let(:response_body) do
          {
            "data" => [
              { "valid_date" => "2024-12-18", "temp" => 10.0 },
              { "valid_date" => "2024-12-19", "temp" => 11.5 }
            ],
            "city_name" => "Paris"
          }.to_json
        end

        before do
          stub_request(:get, url).to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })
        end

        it "returns parsed JSON of the forecast data" do
          result = client.daily_forecast(city: city)
          expect(result["data"]).to be_an(Array)
          expect(result["data"].size).to eq(2)
          expect(result["data"].first["valid_date"]).to eq("2024-12-18")
          expect(result["data"].first["temp"]).to eq(10.0)
        end
      end

      context "when the response is an error" do
        before do
          stub_request(:get, url).to_return(status: 404, body: { error: "Not Found" }.to_json)
        end

        it "raises a WeatherbitApiError" do
          expect {
            client.daily_forecast(city: city)
          }.to raise_error(Weatherbit::WeatherbitApiError, /API Error: 404/)
        end
      end
    end

    context "with no valid parameters" do
      it "raises an ArgumentError" do
        expect {
          client.daily_forecast
        }.to raise_error(Weatherbit::ArgumentError, /You must provide either city or both lat and lng/)
      end
    end
  end

  describe "#current_weather" do
    let(:path) { Weatherbit::Client::CURRENT_WEATHER_PATH }
    context "with lat/lng parameters" do
      let(:url) { "#{base_url}/#{path}?lat=#{lat}&lon=#{lng}&key=#{api_key}" }

      context "when the response is successful" do
        let(:response_body) do
          {
            "data" => [
              { "temp" => 7.2, "weather" => { "description" => "Clear sky" } }
            ],
            "count" => 1
          }.to_json
        end

        before do
          stub_request(:get, url).to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })
        end

        it "returns parsed JSON of the current weather data" do
          result = client.current_weather(lat: lat, lng: lng)
          expect(result["data"]).to be_an(Array)
          expect(result["data"].size).to eq(1)
          expect(result["data"].first["temp"]).to eq(7.2)
        end
      end

      context "when the response is an error" do
        before do
          stub_request(:get, url).to_return(status: 404, body: { error: "Not Found" }.to_json)
        end

        it "raises a WeatherbitApiError" do
          expect {
            client.current_weather(lat: lat, lng: lng)
          }.to raise_error(Weatherbit::WeatherbitApiError, /API Error: 404/)
        end
      end
    end

    context "with city parameter" do
      let(:url) { "#{base_url}/#{path}?city=#{URI.encode_www_form_component(city)}&key=#{api_key}" }

      context "when the response is successful" do
        let(:response_body) do
          {
            "data" => [
              { "temp" => 15.5, "weather" => { "description" => "Partly cloudy" } }
            ],
            "count" => 1
          }.to_json
        end

        before do
          stub_request(:get, url).to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })
        end

        it "returns parsed JSON of the current weather data" do
          result = client.current_weather(city: city)
          expect(result["data"]).to be_an(Array)
          expect(result["data"].size).to eq(1)
          expect(result["data"].first["temp"]).to eq(15.5)
        end
      end

      context "when the response is an error" do
        before do
          stub_request(:get, url).to_return(status: 500, body: { error: "Server Error" }.to_json)
        end

        it "raises a WeatherbitApiError" do
          expect {
            client.current_weather(city: city)
          }.to raise_error(Weatherbit::WeatherbitApiError, /API Error: 500/)
        end
      end
    end

    context "with no valid parameters" do
      it "raises an ArgumentError" do
        expect {
          client.current_weather
        }.to raise_error(Weatherbit::ArgumentError, /You must provide either city or both lat and lng/)
      end
    end
  end
end
