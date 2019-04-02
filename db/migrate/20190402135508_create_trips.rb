class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips do |t|
      t.integer :status, index: true
      t.string :name
      t.date :start_at
      t.string :price
      t.text :description
      t.boolean :download_pdf
      t.boolean :messaging
      t.boolean :overview_map

      t.timestamps
    end
  end
end
