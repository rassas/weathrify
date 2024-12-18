RSpec.shared_context "Mock Weather Service" do
  let(:mock_weather_service) { instance_double(Services::Weather::WeatherService) }
  let(:weather_service_results) do
    {
      city: "Paris",
      date: Date.current,
      temperature: "10°C",
      feels_like: "10°C",
      isDay: true,
      forecast: [
        { day: "Wednesday", date: Date.current, temperature: "9°C", min: "7°C", max: "12°C" },
        { day: "Thursday", date:  Date.current + 1, temperature: "9°C", min: "3°C", max: "12°C" },
        { day: "Friday", date:  Date.current + 2, temperature: "5°C", min: "2°C", max: "7°C" },
        { day: "Saturday", date:  Date.current + 3, temperature: "8°C", min: "7°C", max: "9°C" },
        { day: "Sunday", date:  Date.current + 4, temperature: "7°C", min: "5°C", max: "9°C" }
      ]
    }
  end

  before do
    allow(Services::Weather::WeatherService).to receive(:new).and_return(mock_weather_service)
    allow(mock_weather_service).to receive(:call).and_return(weather_service_results)
  end
end
