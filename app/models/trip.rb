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
#
# Indexes
#
#  index_trips_on_status  (status)
#

class Trip < ApplicationRecord
  has_many :events
end
