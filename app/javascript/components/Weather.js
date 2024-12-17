import h from "components/htm_create_element";
import ForecastRow from "components/ForecastRow";

export default function Weather(weatherData) {
  return(h`
    <div class="weather-container ${weatherData.isDay ? "day" : "night"}">
      <div class="current-weather text-center">
        <h1>${weatherData.city}</h1>
        <p>${weatherData.date}</p>
        <h2>${weatherData.temperature}</h2>
        <p>Feels Like: ${weatherData.feelsLike}</p>
      </div>

      <div class="forecast-card">
        <div class="card-header">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="16"
            height="16"
            fill="currentColor"
            class="calendar-icon"
            viewBox="0 0 16 16"
          >
            <path d="M11 6.5a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-1a.5.5 0 0 1-.5-.5z" />
            <path
              d="M3.5 0a.5.5 0 0 1 .5.5V1h8V.5a.5.5 0 0 1 1 0V1h1a2 2 0 0 1 2 2v11a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V3a2 2 0 0 1 2-2h1V.5a.5.5 0 0 1 .5-.5M1 4v10a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1V4z"
            />
          </svg>
          <span>5-DAY FORECAST</span>
        </div>
        <hr />
        <div class="card-body">
          ${weatherData.forecast.map(
            (day) =>
              h`<${ForecastRow}
                day=${day.day}
                condition=${day.condition}
                min=${day.min}
                max=${day.max}
              />`
          )}
        </div>
      </div>
    </div>
  `);
}
