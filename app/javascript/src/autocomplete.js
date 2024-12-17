document.addEventListener("DOMContentLoaded", function() {
  const input = document.getElementById('autocomplete-input');
  if (input) {
    const autocomplete = new google.maps.places.Autocomplete(input, { types: ['geocode'] });
    autocomplete.addListener('place_changed', function() {
      const place = autocomplete.getPlace();
      console.log(place);
    });
  }
});
