class AddTripIdToEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :trip, foreign_key: true, index: true
  end
end
