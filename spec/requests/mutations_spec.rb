require 'rails_helper'
require 'graphql'
require 'devise/jwt/test_helpers'
# include GraphqlTestHelper

trip_mutation = -> (uuid=nil) { #{{{
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
}#}}}
trip_input = -> (uuid=nil) { #{{{
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
}#}}}

event_mutation = -> (uuid=nil) { #{{{
  return <<~ENDOFMUTATION 
  mutation saveEventMutation($input: SaveEventInput!){
    saveEvent(input: $input) {
      event {
        ... on Activity       { _type uuid title notes day price currency duration starts_at }
        ... on Lodging        { _type uuid title notes day price currency duration starts_at }    
        ... on Flight         { _type uuid title notes day price currency duration starts_at }    
        ... on Transportation { _type uuid title notes day price currency duration starts_at }    
        ... on Cruise         { _type uuid title notes day price currency duration starts_at }    
        ... on Dining         { _type uuid title notes day price currency duration starts_at }    
        ... on Information    { _type uuid title notes day }    
      }
    }
  }
  ENDOFMUTATION
}#}}}
event_input = -> (_type, trip_id, uuid=nil) { #{{{
  event_class_name = _type.to_s.singularize.split(":").last
  input = { 
    _type:     _type,
    title:     "Nice #{ event_class_name }",
    notes:     "Very nice event indeed",
    trip_id:   trip_id,
    day:  1,
    price: 1200,
    currency: "USDa",
    starts_at: "2018-09-10",
    duration: 90.minutes.seconds
  }
  payload = {}
    graphql_type = ("Types::%sType" % [event_class_name] ).constantize
    fields = graphql_type.fields.except("uuid","snippets").keys.each do |field|
      payload[field] = input[field.to_sym]
    end
    payload[:uuid] = uuid if uuid
    payload[:trip_id] = trip_id
  return payload
}#}}}

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
  
  context "Save Event" do
    it "requires authenticated user" do #{{{
      json_params = { "query" => trip_mutation.(), "variables" => { "input" => trip_input.() }}.to_json
      post "/graphql", params:  json_params, headers: @headers
      @response_body = JSON.parse(response.body)
      expect(@response_body["errors"][0]["message"]).to eq("Unauthorized Access Denied")
    end #}}}
    #{{{ create a new event for a given trip
    EVENTS_TYPES.each do |event_type|
      __type = "Event::" + event_type.to_s.singularize.capitalize
      it "should create a new event of type #{__type} for a given trip" do 
        trip = user.trips.create(name: "a new trip")
        input = event_input.(__type, trip.uuid, nil)
        json_params = { "query" => event_mutation.(), "variables" => { "input" => input }}.to_json
        post "/graphql", params:  json_params, headers: @auth_headers
        @response_body = JSON.parse(response.body)
        expect(@response_body["data"]["saveEvent"]["event"].to_json).to match_json_schema("event")
      end
    end #}}}
    #{{{ should update existing trip
    EVENTS_TYPES.each do |event_type|
      __type = "Event::" + event_type.to_s.singularize.capitalize
      it "should update existing event of type #{__type}", now: true do 
        trip = user.trips.create(name: "a new trip") if user.trips.blank?
        trip.events.delete_all
        event = trip.send(event_type).create(title: "nice title")
        input = event_input.(__type, trip.uuid, event.uuid)
        json_params = { "query" => event_mutation.(event.uuid), "variables" => { "input" => input }}.to_json
        post "/graphql", params:  json_params, headers: @auth_headers
        
        @response_body = JSON.parse(response.body)
        expect(@response_body["errors"]).to eq(nil)
        
        new_event = @response_body["data"]["saveEvent"]["event"]
        expect(new_event["_type"]).to eq(__type)
        expect(new_event["uuid"]).to eq(event.uuid)
        
        event_class_name = __type.split(":").last
        input.keys.each do |k|
          expect(new_event[k.to_s]).to eq(input[k]) unless [:trip_id].include?(k)
        end
        expect(new_event).to match_json_schema("event")
        expect(new_event["title"]).to eq("Nice #{event_class_name}")
        expect(new_event["uuid"]).to eq(event.uuid)
      end
    end #}}}
  end

end

