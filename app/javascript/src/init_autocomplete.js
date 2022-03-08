import places from 'places.js';
const initAutocomplete = () => {
  const addressInput = document.querySelector('#geo-address');
  if (addressInput) {
    const autocomplete = places({ container: addressInput });

    autocomplete.on('change', (e) => {
      const event = new CustomEvent('latlngChange', { detail: { lat: e.suggestion.latlng.lat, long: e.suggestion.latlng.lng }});
      addressInput.dispatchEvent(event);
    })
  }
};

export { initAutocomplete };
