class CreateInventoryItems < ActiveRecord::Migration[8.1]
  def change
    create_table :inventory_items do |t|
      t.references :player, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
    add_index :inventory_items, [ :player_id, :item_id ]
  end
end
