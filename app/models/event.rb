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
#

class Event < ApplicationRecord
  
  translates :title, :notes, :details
  belongs_to :trip

  #(0..100).map{|q| q * 15 * 60}.map{|q| p ActiveSupport::Duration.build(q).parts}
end
