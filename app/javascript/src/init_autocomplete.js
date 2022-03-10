import places from 'places.js';

const initAutocomplete = () => {

  const addressInput = document.querySelector('#geo-address');
  const latInput = document.querySelector('#geo-lat');
  const longInput = document.querySelector('#geo-long');

  if (addressInput) {
    const autocomplete = places({
                                  language: 'fr',
                                  container: addressInput,
                                  countries: ['fr'],
                                  aroundLatLng: [45.8802348, 4.5645336] ,
                                  aroundRadius: 50000
                               });

    autocomplete.on('change', (e) => {
      const event = new CustomEvent('latlngChange', { detail: { lat: e.suggestion.latlng.lat, long: e.suggestion.latlng.lng }});
      addressInput.dispatchEvent(event);

      if (latInput)
        latInput.value = e.suggestion.latlng.lat
      if (longInput)
        longInput.value = e.suggestion.latlng.lng
    })
  }
};

export { initAutocomplete };
