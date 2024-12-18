document.addEventListener("DOMContentLoaded", function () {
  const urlParams = new URLSearchParams(window.location.search);
  const cityParam = urlParams.get('city');

  const input = document.getElementById('autocomplete-input');

  if (cityParam && input) {
    input.value = cityParam;
  }

  if (input) {
    const autocomplete = new google.maps.places.Autocomplete(input, { types: ['geocode'] });
    autocomplete.addListener('place_changed', function () {
      const place = autocomplete.getPlace();

      const currentUrl = new URL(window.location.href);
      currentUrl.searchParams.set('city', place.formatted_address);
      currentUrl.searchParams.set('lat', place.geometry.location.lat());
      currentUrl.searchParams.set('lng', place.geometry.location.lng());

      window.location.href = currentUrl.toString();
    });
  }
});
