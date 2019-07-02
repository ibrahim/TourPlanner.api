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

class Event::Base < ApplicationRecord
  
  include BinaryUuidPk
  include Events
  
  
  #(0..100).map{|q| q * 15 * 60}.map{|q| p ActiveSupport::Duration.build(q).parts}
end
