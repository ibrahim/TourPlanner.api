require 'rails_helper'
require 'graphql'
require 'devise/jwt/test_helpers'

RSpec.describe 'GraphQl Mutations', type: :request do
  let(:url) { '/gaphql' }
  let(:user) do
    Fabricate(:user)
  end
  before do
    @headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    @auth_headers = Devise::JWT::TestHelpers.auth_headers(@headers, user)
  end

  context "Save Trip Mutation" do
      #{{{ query
    let(:query){
      query = <<~ENDOFMUTATION 
              mutation saveTripMutation($input: SaveTripInput!){
                saveTrip(input: $input) {
                  trip {
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
      #}}}
      #{{{ input
    let(:input){
      input = { 
            status: 0,
            name: "Nice Trip",
            start_at: "2018-09-10",
            price: "starting from 1200 USD",
            description: "Very nice trip indeed",
            download_pdf: true,
            messaging: true,
            overview_map: true
          } 
    }
      #}}}
    it "Save Trip requires authenticated user" do
      json_params = { "query" => query, "variables" => { "input" => input }}.to_json
      post "/graphql", params:  json_params, headers: @headers
      @response_body = JSON.parse(response.body)
      expect(@response_body["errors"][0]["message"]).to eq("Unauthorized Access Denied")
    end

    it "Save Trip create a new trip for signed in user" do
      json_params = { "query" => query, "variables" => { "input" => input }}.to_json
      post "/graphql", params:  json_params, headers: @auth_headers
      @response_body = JSON.parse(response.body)
      expect(@response_body["data"]["saveTrip"]["trip"].to_json).to eq(input.to_json)
    end
  end

end

