class AddExtendedEquipmentSlotsToPlayers < ActiveRecord::Migration[8.1]
  def change
    add_reference :players, :equipped_cape, foreign_key: { to_table: :items }
    add_reference :players, :equipped_chest, foreign_key: { to_table: :items }
    add_reference :players, :equipped_weapon_2h, foreign_key: { to_table: :items }
    add_reference :players, :equipped_staff, foreign_key: { to_table: :items }
    add_reference :players, :equipped_legs, foreign_key: { to_table: :items }
    add_reference :players, :equipped_boots, foreign_key: { to_table: :items }
    add_reference :players, :equipped_gloves, foreign_key: { to_table: :items }
    add_reference :players, :equipped_belt, foreign_key: { to_table: :items }
  end
end
