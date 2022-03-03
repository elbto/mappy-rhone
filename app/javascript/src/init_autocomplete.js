import places from 'places.js';
const initAutocomplete = () => {
  const addressInput = document.querySelector('#geo-address');
  console.log(addressInput);
  if (addressInput) {
    places({ container: addressInput });
  }
};

export { initAutocomplete };
