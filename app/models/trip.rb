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

class Trip < ApplicationRecord
  include BinaryUuidPk
  has_many :events, class_name: "Event::Base"
  has_many :activities, class_name: "Event::Activity"
  has_many :flights, class_name: "Event::Flight"
  has_many :transportations, class_name: "Event::Transportation"
  has_many :cruises, class_name: "Event::Cruise"
  has_many :informations, class_name: "Event::Information"
  has_many :lodgings, class_name: "Event::Lodging"
  has_many :dinings, class_name: "Event::Dining"
  has_many :sections
  belongs_to :user

  def association_for(event_type)
    case event_type.split("::").last.downcase
    when "information"
      return informations
    when "activity"
      return activities
    when "lodging"
      return lodgings
    when "flight"
      return flights
    when "transportation"
      return transportations
    when "cruise"
      return cruises
    when "dining"
      return dinings

    end
  end
end
