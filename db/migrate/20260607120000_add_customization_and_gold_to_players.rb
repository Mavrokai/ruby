class AddCustomizationAndGoldToPlayers < ActiveRecord::Migration[8.1]
  def change
    add_column :players, :gold, :integer, null: false, default: 50
    add_column :players, :accent_color, :string, null: false, default: "#d4a44a"
  end
end
