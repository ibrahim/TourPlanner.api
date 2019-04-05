class AddBitFieldToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :roles_mask, :integer, default: 0, null: false
  end
end
