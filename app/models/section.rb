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
end
