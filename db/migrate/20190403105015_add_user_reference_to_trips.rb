class AddUserReferenceToTrips < ActiveRecord::Migration[5.2]
  def change
    # add_reference :trips, :user, foreign_key: true, index: true
    add_column :trips, :user_id, :binary, limit: 16, foreign_key: true, index: true
  end
end
