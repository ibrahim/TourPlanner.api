# == Schema Information
#
# Table name: events
#
#  id         :bigint(8)        not null, primary key
#  currency   :string(255)
#  day        :integer
#  duration   :integer
#  price      :integer
#  starts_at  :string(255)
#  timezone   :string(255)
#  type       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trip_id    :bigint(8)
#
# Indexes
#
#  index_events_on_trip_id  (trip_id)
#
# Foreign Keys
#
#  fk_rails_...  (trip_id => trips.id)
#

class Event::Lodging < Event::Base
  belongs_to :trip
end
