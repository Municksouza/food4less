Geocoder.configure(
    timeout: 5,                 # timeout for requests
    lookup: :mapbox,            # provider (can be :nominatim, :google, etc.)
    api_key: ENV["MAPBOX_API_TOKEN"], # API key for geocoding service
    units: :km,                 # units (:km or :mi)
    distances: :linear,
    always_raise: [],
    default_country: 'CA'
)