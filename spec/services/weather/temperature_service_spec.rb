require 'rails_helper'

RSpec.describe Services::Weather::TemperatureService do
  let(:api_key) { "test_api_key" }
  let(:client_double) { instance_double(Weatherbit::Client) }

  before do
    allow(Weatherbit::Client).to receive(:new).and_return(client_double)
    allow(Rails.application.credentials).to receive(:weatherbit_apikey).and_return(api_key)
  end

  describe "#call" do
    context "when all cities return temperatures" do
      let(:city_list) { ["Paris", "London", "Berlin"] }
      let(:temperatures) { [10.0, 15.0, 20.0] }

      before do
        city_list.zip(temperatures).each do |city, temp|
          allow(client_double).to receive(:current_weather)
            .with(city: city)
            .and_return({ "data" => [{ "temp" => temp }] })
        end
      end

      it "returns the average temperature" do
        service = described_class.new(city_list)
        result = service.call
        expect(result).to eq(15.0)
      end
    end

    context "when the city_list is empty" do
      let(:city_list) { [] }

      it "raises a FetchTemperatureError because no temperatures can be fetched" do
        service = described_class.new(city_list)
        expect { service.call }.to raise_error(Services::Weather::TemperatureService::FetchTemperatureError)
      end
    end
  end
end
