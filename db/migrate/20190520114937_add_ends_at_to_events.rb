class AddEndsAtToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :ends_at, :float
  end
end
