class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :type
      t.string :starts_at
      t.integer :price
      t.string :currency
      t.integer :day, limit: 2
      t.integer :duration
      t.string :timezone

      t.timestamps
    end
  end
end
