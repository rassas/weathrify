document.addEventListener("DOMContentLoaded", () => {
  const weatherContainer = document.querySelector(".weather-container");
  const cityNameElement = document.getElementById("city-name");
  const currentDateElement = document.getElementById("current-date");
  const temperatureElement = document.getElementById("temperature");
  const feelsLikeElement = document.getElementById("feels-like");

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
    ],
  };

  function updateWeatherUI(data) {
    cityNameElement.textContent = data.city;
    currentDateElement.textContent = data.date;
    temperatureElement.textContent = data.temperature;
    feelsLikeElement.textContent = `Feels Like: ${data.feelsLike}`;

    weatherContainer.classList.toggle("day", data.isDay);
    weatherContainer.classList.toggle("night", !data.isDay);
  }

  updateWeatherUI(weatherData);
});
