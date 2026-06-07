class CreateMarketListings < ActiveRecord::Migration[8.1]
  def change
    create_table :market_listings do |t|
      t.references :item, null: false, foreign_key: true
      t.references :seller, foreign_key: { to_table: :players }
      t.references :buyer, foreign_key: { to_table: :players }
      t.references :inventory_item, foreign_key: true
      t.integer :price, null: false, default: 0
      t.string :status, null: false, default: "active"

      t.timestamps
    end
    add_index :market_listings, :status
  end
end
