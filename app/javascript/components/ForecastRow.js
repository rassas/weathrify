import h from "components/htm_create_element";

export default function ForecastRow({ day, min, max, date, temperature, onRowClick }) {
  const handleClick = () => {
    if (onRowClick) {
      onRowClick({ day, min, max, date, temperature });
    }
  };

  return(h`
    <div class="forecast-row" onClick=${handleClick}>
      <span class="day-name">${day}</span>
      <span class="min-temp">Min: ${min}</span>
      <span class="max-temp">Max: ${max}</span>
    </div>
    <hr />
  `);
}
