require 'rails_helper'
require 'graphql'
require 'devise/jwt/test_helpers'
# include GraphqlTestHelper

trip_mutation = -> (uuid=nil) { 
      return <<~ENDOFMUTATION 
              mutation saveTripMutation($input: SaveTripInput!){
                saveTrip(input: $input) {
                  trip {
                    uuid
                    status
                    name
                    start_at
                    price
                    description
                    download_pdf
                    messaging
                    overview_map
                  }
                }
              }
      ENDOFMUTATION
}
trip_input = -> (uuid=nil) {
      input = { 
            status:        0,
            name:          "Nice Trip",
            start_at:      "2018-09-10",
            price:         "starting from 1200 USD",
            description:   "Very nice trip indeed",
            download_pdf:  true,
            messaging:     true,
            overview_map:  true
          } 
      input[:uuid] = uuid if uuid
      return input
}

RSpec.describe 'GraphQl Mutations', type: :request do
  let(:url) { '/gaphql' }
  let(:user) do
    Fabricate(:user)
  end
  before do
    @headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    @auth_headers = Devise::JWT::TestHelpers.auth_headers(@headers, user)
  end

  context "Save Trip" do
    it "requires authenticated user" do #{{{
      json_params = { "query" => trip_mutation.(), "variables" => { "input" => trip_input.() }}.to_json
      post "/graphql", params:  json_params, headers: @headers
      @response_body = JSON.parse(response.body)
      expect(@response_body["errors"][0]["message"]).to eq("Unauthorized Access Denied")
    end #}}}
    it "create a new trip for signed in user" do #{{{
      input = trip_input.()
      json_params = { "query" => trip_mutation.(), "variables" => { "input" => input }}.to_json
      post "/graphql", params:  json_params, headers: @auth_headers
      @response_body = JSON.parse(response.body)
      # expect(@response_body["data"]["saveTrip"]["trip"].to_json).to eq(input.to_json)
      expect(@response_body["data"]["saveTrip"]["trip"].to_json).to match_json_schema('trip')
    end #}}}
    it "should update existing trip" do #{{{
      trip = user.trips.create(name: "a new trip")
      input = trip_input.(trip.uuid)
      json_params = { "query" => trip_mutation.(trip.uuid), "variables" => { "input" => input }}.to_json
      post "/graphql", params:  json_params, headers: @auth_headers
      @response_body = JSON.parse(response.body)
      expect(@response_body["data"]["saveTrip"]["trip"].to_json).to match_json_schema("trip")
      expect(@response_body["data"]["saveTrip"]["trip"]["uuid"]).to eq(trip.uuid)
    end #}}}
  end

end

