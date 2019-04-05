require 'rails_helper'
require 'graphql'
require 'devise/jwt/test_helpers'

current_user_query = "{ current_user { email } }"
snippets_fragments = <<-EOS
... on Info {
  _type
  title
  icon
}
... on Place {
  _type
  title
  vicinity
  lat               
  lng                   
  name                  
  icon                  
  types                 
  formatted_phone_number
  formatted_address 
  address_components    
  rating                
  url                   
  reference             
}
EOS
user_trips_query = <<-EOS
  { current_user {
      trips {
        name
        events {
        ... on Activity       { _type title price snippets { #{snippets_fragments} }}
        ... on Lodging        { _type title price snippets { #{snippets_fragments} }}    
        ... on Flight         { _type title price snippets { #{snippets_fragments} }}    
        ... on Transportation { _type title price snippets { #{snippets_fragments} }}    
        ... on Cruise         { _type title price snippets { #{snippets_fragments} }}    
        ... on Information    { _type title       snippets { #{snippets_fragments} }}    
        ... on Dining         { _type title       snippets { #{snippets_fragments} }}    
        }
      }
    }
  }
EOS
  

RSpec.describe 'GraphQl API', type: :request do
  let(:user) do
    Fabricate(:user) do
      trips(count: 1)
    end
  end
  let(:url) { '/gaphql' }
  let(:login_url) { '/login' }
  let(:params) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  before do
    @headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    @auth_headers = Devise::JWT::TestHelpers.auth_headers(@headers, user)
  end

  context 'When query current_user' do
    it "Deny access for unauthenticated user" do
      post "/graphql", params:  { "query" => current_user_query }.to_json, headers: @headers
      response_body = JSON.parse(response.body)
      expect(response_body["errors"].first["message"]).to eq("Unauthorized Access Denied") 
    end

    it "Return current_user for authenticated user" do
      post "/graphql", params:  { "query" => current_user_query }.to_json, headers: @auth_headers
      response_body = JSON.parse(response.body)
      expect(response_body["data"]).to eq( 
        { "current_user" => { "email" => "username@example.com" } }
      )
    end 
  end

  context "When query current_user trips" do
    before do
      post "/graphql", params:  { "query" => user_trips_query }.to_json, headers: @auth_headers
      @response_body = JSON.parse(response.body)
    end
    it "should not return errors" do
      expect(@response_body["errors"]).to eq(nil)
    end
    it "should return user's trips" do
      _user = @response_body["data"]["current_user"]
      _trips = _user["trips"]
      _trip = _trips[0]
      _name = _trip["name"]
      expect(_name).to eq("Cairo Trip")
    end
    it "should return all events types for user's trip" do
      events = @response_body["data"]["current_user"]["trips"][0]["events"]
      aggregate_failures "trip events" do
        expect(events.count).to eq(EVENTS_TYPES.length)
        expect(events.map{|e| e["_type"]}).to match_array(EVENTS_TYPES.map{|t| t.to_s.singularize.capitalize})
      end
    end
    it "should return all snippets types for user's trip events" do
      #snippets = @response_body["data"]["current_user"]["trips"][0]["activities"][0]["snippets"]
      _user = @response_body["data"]["current_user"]
      _trips    = _user["trips"]
      _trip     = _trips[0]
      _events   = _trip["events"]
      _activity = _events[0]
      snippets = _activity["snippets"]
      aggregate_failures "events snippets" do
        expect(snippets.count).to eq(SNIPPETS_TYPES.length)
        expect(snippets.map{|e| e["_type"]}).to match_array(SNIPPETS_TYPES.map{|t| t.to_s.singularize.capitalize})
      end
    end
  end

end

