require 'rails_helper'
require 'graphql'
require 'devise/jwt/test_helpers'

current_user_query = "{ current_user { email } }"
user_trips_query = <<-EOS
  { current_user {
      trips {
        name
        events {
          ... on Activity { event_type title price }    
          ... on Lodging  { event_type title price }    
          ... on Flight   { event_type title price }    
          ... on Transportation { event_type title price }    
          ... on Cruise { event_type title price }    
          ... on Information { event_type title }    
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
    it "should return user's trips" do
      expect(@response_body["data"]["current_user"]["trips"][0]["name"]).to eq("Cairo Trip")
    end
    it "should return all events types for user's trip" do
      events = @response_body["data"]["current_user"]["trips"][0]["events"]
      aggregate_failures "trip events" do
        expect(events.count).to eq(6)
        expect(events.map{|e| e["event_type"]}).to match_array(["Activity","Lodging","Flight","Transportation","Cruise","Information"])
      end
    end
  end

end

