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

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
