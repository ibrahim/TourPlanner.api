
# vicinity:                the street or neighborhood of the spot
# lat:                     the latitude of the spot
# lng:                     the longitude of the spot
# name:                    the name of the spot
# icon:                    a URL to the icon of this spot
# types:                   array of feature types describing the spot, see list of supported types
# formatted_phone_number:  formatted phone number of the spot (eg (555)555-555)
# formatted_address:       the full address of the spot formatted with commas
# address_components:      the components (eg street address, city, state) of the spot's address in an array
# rating:                  the rating of this spot on Google Places
# url:                     the url of this spot on Google Places
# reference:               a token to query the Google Places API for more details about the spot

class Snippet::Place < Snippet::Base
  include Snippets
  DETAILS = [:vicinity, :lat, :lng, :name, :icon, :types, :formatted_phone_number, :formatted_address, :address_components, :rating, :url, :reference]
  store :details, accessors: DETAILS, coder: JSON
end
