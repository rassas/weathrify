import { createRoot } from "react-dom-client";
import h from "components/htm_create_element";
import Weather from "components/Weather";

document.addEventListener("DOMContentLoaded", () => {
  const weatherElement = document.getElementById("react-weather")
  if (weatherElement) {
    const root = createRoot(weatherElement);
    const weatherData = {
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
    root.render(h`<${Weather} weatherData="${weatherData}"/>`);
  }
});
