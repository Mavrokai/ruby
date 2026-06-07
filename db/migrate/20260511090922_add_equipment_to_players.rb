class AddEquipmentToPlayers < ActiveRecord::Migration[8.1]
  def change
    add_reference :players, :equipped_hat, foreign_key: { to_table: :items }
    add_reference :players, :equipped_weapon, foreign_key: { to_table: :items }
    add_reference :players, :equipped_shield, foreign_key: { to_table: :items }
  end
end
