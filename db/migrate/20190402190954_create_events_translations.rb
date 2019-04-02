class CreateEventsTranslations < ActiveRecord::Migration[5.2]
  def change
    Event.create_translation_table! :title => :string, :notes => :text, details: :text
  end
end
