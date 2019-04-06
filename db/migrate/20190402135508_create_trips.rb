class CreateTrips < ActiveRecord::Migration[5.2]
  def change
    create_table :trips, id: false do |t|
      t.binary   :id, limit: 16, primary_key: true, null: false
      t.virtual  :uuid, type: :string, limit: 36, as: "insert( insert( insert( insert( hex(id),9,0,'-' ), 14,0,'-' ), 19,0,'-' ), 24,0,'-' )"
      t.integer  :status, index: true
      t.string   :name
      t.date     :start_at
      t.string   :price
      t.text     :description
      t.boolean  :download_pdf
      t.boolean  :messaging
      t.boolean  :overview_map

      t.timestamps
    end
  end
end
