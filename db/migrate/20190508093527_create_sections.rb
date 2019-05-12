class CreateSections < ActiveRecord::Migration[5.2]
  def change
    create_table :sections, id: false do |t|
      t.binary   :id, limit: 16, primary_key: true, null: false
      t.virtual  :uuid, type: :string, limit: 36, as: "insert( insert( insert( insert( hex(id),9,0,'-' ), 14,0,'-' ), 19,0,'-' ), 24,0,'-' )"
      t.string :title
      t.boolean :is_day
      t.integer :day_order
      t.datetime :day_date

      t.timestamps
    end
    add_column :sections, :trip_id, :binary, limit: 16, foreign_key: true, index: true
  end
end
