# == Schema Information
#
# Table name: users
#
#  id                     :binary(16)       not null, primary key
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
#  uuid                   :string(36)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){ Fabricate(:user){ trips(count: 1)}}
    it "has a fabrication" do
      expect(user.email).to eq("username@example.com")
    end
    it "has trips" do
      expect(user.trips.count).to eq(1)
    end
    context "Setting user's Roles" do #{{{
      it "should have admin role" do
        user.admin = true
        user.save
        expect(user.admin).to eq(true)
      end
      it "should have marketing_officer role" do
        user.marketing_officer = true
        user.save
        expect(user.marketing_officer).to eq(true)
      end
      it "should have sales_manager role" do
        user.sales_manager = true
        user.save
        expect(user.sales_manager).to eq(true)
      end
      it "should have sales_officer role" do
        user.sales_officer = true
        user.save
        expect(user.sales_officer).to eq(true)
      end
    end #}}}
end
