require 'geocoder'

Geocoder.configure(lookup: :test)

Geocoder::Lookup::Test.set_default_stub(
  [
    {
      'latitude'     => 52.133,
      'longitude'    => -106.634,
      'address'      => "Default address",
      'state'        => "Saskatchewan",
      'state_code'   => "SK",
      'country'      => "Canada",
      'country_code' => "CA"
    }
  ]
)