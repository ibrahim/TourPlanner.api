class CreateEventsTranslations < ActiveRecord::Migration[5.2]
  def change
    Event::Base.create_translation_table! :title => :string, :notes => :text
  end
end
