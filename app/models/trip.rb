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

class Trip < ApplicationRecord
  has_many :events, class_name: "Event::Base"
  has_many :activities, class_name: "Event::Activity"
  has_many :flights, class_name: "Event::Flight"
  has_many :transportations, class_name: "Event::Transportation"
  has_many :cruises, class_name: "Event::Cruise"
  has_many :informations, class_name: "Event::Information"
  has_many :lodgings, class_name: "Event::Lodging"
  has_many :dinings, class_name: "Event::Dining"
  belongs_to :user
end
