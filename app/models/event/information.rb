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

class Event::Information < Event::Base
  include Events
  DETAILS = [:info_type]
  store :details, accessors: DETAILS, coder: JSON
end
