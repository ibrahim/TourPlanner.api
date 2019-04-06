# == Schema Information
#
# Table name: trips
#
#  id           :binary(16)       not null, primary key
#  description  :text(65535)
#  download_pdf :boolean
#  messaging    :boolean
#  name         :string(255)
#  overview_map :boolean
#  price        :string(255)
#  start_at     :date
#  status       :integer
#  uuid         :string(36)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :binary(16)
#
# Indexes
#
#  index_trips_on_status  (status)
#

require 'rails_helper'

RSpec.describe Trip, type: :request do
  let(:user){ Fabricate(:user)}
  let(:trip){ Fabricate(:trip, user: user)}
  
  it "belongs to a user" do
    expect(trip.user).to eq(user)
  end

  it "has all required events types associations" do
    expect(trip.name).to eq("Cairo Trip")
    # [:activities, :lodgings, :flights, :transportations, :cruises, :info ]
    expect(trip.activities.first.title).to eq("nice activity")
    expect(trip.lodgings.first.title).to eq("nice hotel")
    expect(trip.flights.first.title).to eq("nice flight")
    expect(trip.transportations.first.title).to eq("nice transportation")
    expect(trip.cruises.first.title).to eq("nice cruise")
    expect(trip.informations.first.title).to eq("nice information")
  end
end
