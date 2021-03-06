# == Schema Information
#
# Table name: events
#
#  id         :binary(16)       not null, primary key
#  currency   :string(255)
#  day        :integer
#  details    :text(65535)
#  duration   :integer
#  ends_at    :float(24)
#  price      :integer
#  starts_at  :string(255)
#  timezone   :string(255)
#  type       :string(255)
#  uuid       :string(36)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  section_id :binary(16)
#  trip_id    :binary(16)
#

class Event::Flight < Event::Base
  include Events
  DETAILS = [:booked_through, :confirmation, :airline, :flight_number, :terminal, :gate]
  store :details, accessors: DETAILS, coder: JSON
end
