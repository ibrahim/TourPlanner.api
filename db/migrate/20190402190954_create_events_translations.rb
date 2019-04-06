class CreateEventsTranslations < ActiveRecord::Migration[5.2]
  def change
    create_table :event_translations do |t|
      t.binary   :event_id, limit: 16
      t.string   :locale, :null => false, index: true
      t.string   :title
      t.text     :notes
      t.timestamps
    end
  end
end
