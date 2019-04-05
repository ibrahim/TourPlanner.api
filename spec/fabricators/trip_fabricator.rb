# == Schema Information
#
# Table name: trips
#
#  id           :bigint(8)        not null, primary key
#  description  :text(65535)
#  download_pdf :boolean
#  messaging    :boolean
#  name         :string(255)
#  overview_map :boolean
#  price        :string(255)
#  start_at     :date
#  status       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint(8)
#
# Indexes
#
#  index_trips_on_status   (status)
#  index_trips_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

Fabricator(:trip) do
  description "Lovely trip"
  name "Cairo Trip"
  price "90"
  activities(count: 1, fabricator: :activity)
  lodgings(count: 1, fabricator: :lodging)
  flights(count: 1, fabricator: :flight)
  transportations(count: 1, fabricator: :transportation)
  cruises(count: 1, fabricator: :cruise)
  informations(count: 1, fabricator: :information)
  dinings(count: 1, fabricator: :dining)
end
