class CreateJwtBlacklist < ActiveRecord::Migration[5.2]
  def change
    # bin_to_uuid = "insert( insert( insert( insert( hex(id),9,0,'-' ), 14,0,'-' ), 19,0,'-' ), 24,0,'-' )"
    create_table :jwt_blacklist, id: false do |t|
      t.binary   :id, limit: 16, primary_key: true, null: false
      # t.virtual  :uuid, type: :string, limit: 36, as: bin_to_uuid
      t.string :jti, null: false
    end
    add_index :jwt_blacklist, :jti
  end
end
