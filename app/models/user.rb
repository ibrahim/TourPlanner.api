# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  roles_mask             :integer          default(0), not null
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  
  include Bitfields

  bitfield :roles_mask, 
    1 => :admin, 
    2 => :marketing_officer, 
    4 => :sales_manager,
    8 => :sales_officer 

  ROLES = [ :admin, :marketing_officer, :sales_manager, :sales_officer ]

  devise :database_authenticatable, :registerable, :jwt_authenticatable, jwt_revocation_strategy: JWTBlacklist

    # :recoverable, 
    # :rememberable, 
    # :validatable, 
    # :confirmable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable


  has_many :trips

  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  # def jwt_payload
  #   { 'foo' => 'bar' }
  # end

end
