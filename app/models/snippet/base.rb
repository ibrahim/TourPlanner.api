# == Schema Information
#
# Table name: snippets
#
#  id          :binary(16)       not null, primary key
#  address     :string(255)
#  description :text(65535)
#  details     :text(4294967295)
#  library     :boolean
#  link        :string(255)
#  owner_type  :string(255)
#  phone       :string(255)
#  thumbnail   :string(255)
#  title       :string(255)
#  type        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  owner_id    :binary(16)
#
# Indexes
#
#  index_snippets_on_library                  (library)
#  index_snippets_on_owner_id_and_owner_type  (owner_id,owner_type)
#

class Snippet::Base < ApplicationRecord
  self.table_name = "snippets"
  include BinaryUuidPk
end
