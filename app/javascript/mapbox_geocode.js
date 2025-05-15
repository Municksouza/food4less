document.addEventListener('DOMContentLoaded', () => {
  const addressInput = document.getElementById('store_address');
  
  if (!addressInput) return;
  
  addressInput.addEventListener('blur', () => {
    const address = addressInput.value;
    if (!address) return;
  
    const token = document.querySelector('meta[name="mapbox-token"]').content;
    const url = `https://api.mapbox.com/geocoding/v5/mapbox.places/${encodeURIComponent(address)}.json?access_token=${token}`;
  
    fetch(url)
    .then(response => response.json())
    .then(data => {
      if (data.features && data.features.length > 0) {
      const [lng, lat] = data.features[0].center;
      document.getElementById('store_latitude').value = lat;
      document.getElementById('store_longitude').value = lng;
      } else {
      alert('Address not found.');
      }
    })
    .catch(error => {
      console.error('Error fetching location:', error);
    });
  });
});