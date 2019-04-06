class CreateSnippets < ActiveRecord::Migration[5.2]
  def change
    create_table :snippets, id: false do |t|
      t.binary    :id, limit: 16, primary_key: true, null: false
      t.string    :type
      t.string    :title
      t.text      :description
      t.string    :link
      t.string    :phone
      t.string    :thumbnail
      t.string    :address
      t.longtext  :details
      t.boolean   :library
      t.string    :owner_type
      t.binary    :owner_id, limit: 16
      t.timestamps
    end
    add_index :snippets, [:owner_id, :owner_type]
    add_index :snippets, [:library]
  end
end
