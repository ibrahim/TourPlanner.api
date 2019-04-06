class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events, id: false do |t|
      t.binary   :id, limit: 16, primary_key: true, null: false
      t.virtual  :uuid, type: :string, limit: 36, as: "insert( insert( insert( insert( hex(id),9,0,'-' ), 14,0,'-' ), 19,0,'-' ), 24,0,'-' )"
      t.string   :type
      t.string   :starts_at
      t.integer  :price
      t.string   :currency
      t.integer  :day, limit: 2
      t.integer  :duration
      t.string   :timezone

      t.timestamps
    end
  end
end
