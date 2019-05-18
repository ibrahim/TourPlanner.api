# == Schema Information
#
# Table name: sections
#
#  id         :binary(16)       not null, primary key
#  day_date   :datetime
#  day_order  :integer
#  is_day     :boolean
#  title      :string(255)
#  uuid       :string(36)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  trip_id    :binary(16)
#

class Section < ApplicationRecord
  include BinaryUuidPk
  belongs_to :trip
  has_many :events, class_name: "Event::Base"
  has_many :activities, class_name: "Event::Activity"
  has_many :flights, class_name: "Event::Flight"
  has_many :transportations, class_name: "Event::Transportation"
  has_many :cruises, class_name: "Event::Cruise"
  has_many :informations, class_name: "Event::Information"
  has_many :lodgings, class_name: "Event::Lodging"
  has_many :dinings, class_name: "Event::Dining"
end
