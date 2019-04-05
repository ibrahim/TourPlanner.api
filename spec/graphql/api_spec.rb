require 'rails_helper'

describe Types::UserType do
  context "Graphql User Type" do 
    it 'defines a field trips' do
      expect(subject).to have_field(:trips).that_returns([Types::TripType])
    end
    # it { is_expected.to have_field(:id).of_type("ID!") }
    # it { is_expected.to have_a_field(:id).returning("ID!") }
  end

end
describe Types::TripType do
  it 'defines a field events for trips' do
    expect(subject).to have_field(:events).that_returns([Types::EventType])
  end

  # Fluent alternatives
  # it { is_expected.to have_field(:id).of_type("ID!") }
  # it { is_expected.to have_a_field(:id).returning("ID!") }
end

describe Types::QueryType do
  it "defines a field to return  current authenticated user (current_user)" do
    expect(subject).to have_field(:current_user).that_returns(Types::UserType)
  end
end
