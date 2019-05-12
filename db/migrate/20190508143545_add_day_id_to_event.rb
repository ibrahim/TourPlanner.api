class AddDayIdToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :section_id, :binary, limit: 16, foreign_key: true, index: true
  end
end
