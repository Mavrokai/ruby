class CreateItems < ActiveRecord::Migration[8.1]
  SLOTS = %w[hat weapon shield].freeze

  def change
    create_table :items do |t|
      t.string :name, null: false
      t.string :slot, null: false
      t.integer :force_bonus, null: false, default: 0
      t.integer :health_bonus, null: false, default: 0
      t.integer :xp_bonus, null: false, default: 0
      t.text :description

      t.timestamps
    end
    add_index :items, :slot
  end
end
