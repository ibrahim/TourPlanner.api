# == Schema Information
#
# Table name: events
#
#  id         :binary(16)       not null, primary key
#  currency   :string(255)
#  day        :integer
#  details    :text(65535)
#  duration   :integer
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

class Event::Cruise < Event::Base
  include Events
  belongs_to :trip
  DETAILS = [:booked_through, :confirmation, :carrier, :cabin_type, :cabin_number]
  store :details, accessors: DETAILS, coder: JSON
end
