require 'rails_helper'
require 'graphql'
require 'devise/jwt/test_helpers'

current_user_query = <<-ENDOS
  { current_user {
        email
      }
  }
ENDOS
  

RSpec.describe 'GraphQl API', type: :request do
  let(:user) do
    Fabricate(:user)
  end
  let(:trip) do
      Fabricate(:trip, user: user)
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


  
  context 'When query current_user' do

    before do
      headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
      @auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
    end

    it "should deny access unless user authenticated" do
      post "/graphql", params: { "query":  current_user_query }
      response_body = JSON.parse(response.body)
      expect(response_body["errors"].first["message"]).to eq("Unauthorized Access Denied") 
    end

    it "returns a current_user if user is authenticated" do
      post "/graphql", params:  { "query" => current_user_query }.to_json, headers: @auth_headers
      response_body = JSON.parse(response.body)
      expect(response_body["data"]).to eq( 
        { "current_user" => { "email" => "username@example.com" } }
      )
    end 

  end

  # context 'When query a trip with an ID' do
  #
  #   it "returns a collection of trip" do
  #     # building_permit = create(:building_permit)
  #     #
  #     # post "/graphql", params: { "query"=>"{\n  buildingPermits(limit: 10) {\n    id\n  }\n}" }
  #     #
  #     # response_body = JSON.parse(response.body)
  #     #
  #     # expect(response_body).to eq( 
  #     #   {"data"=>{"buildingPermits"=>[{"id"=>building_permit.id}]}}
  #     # )
  #   end 
  # end

end

