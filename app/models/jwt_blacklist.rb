# == Schema Information
#
# Table name: jwt_blacklist
#
#  id  :bigint(8)        not null, primary key
#  exp :datetime         not null
#  jti :string(255)      not null
#
# Indexes
#
#  index_jwt_blacklist_on_jti  (jti)
#

class JWTBlacklist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Blacklist

  self.table_name = 'jwt_blacklist'
end
