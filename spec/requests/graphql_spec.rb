require 'rails_helper'
require 'graphql'

RSpec.describe 'GraphQl API', type: :request do
  let(:user) do
    Fabricate(:user)
  end
  Fabricate(:user, name: 'Operator', email: "operator@ugo.tours") do
    trips do 
      [ Fabricate(:trip) ] 
    end
  end
  let(:url) { '/gaphql' }
  let(:query) do
    {
      user: {
        email: user.email,
        password: user.password
      }
    }
  end

  context 'when params are correct' do
  #   before do
  #     post url, params: params
  #   end
  #   
  #   it 'returns 200' do
  #     expect(response).to have_http_status(200)
  #   end
    it "returns a collection of trip" do
      building_permit = create(:building_permit)

      post "/graphql", params: { "query"=>"{\n  buildingPermits(limit: 10) {\n    id\n  }\n}" }
      
      response_body = JSON.parse(response.body)

      expect(response_body).to eq( 
        {"data"=>{"buildingPermits"=>[{"id"=>building_permit.id}]}}
      )
    end 
  end

end

