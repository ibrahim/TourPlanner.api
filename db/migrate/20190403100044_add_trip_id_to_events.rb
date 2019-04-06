class AddTripIdToEvents < ActiveRecord::Migration[5.2]
  def change
    # add_reference :events, :trip, foreign_key: true, index: true
    add_column :events, :trip_id, :binary, limit: 16, foreign_key: true, index: true
  end
end
