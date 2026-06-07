require "test_helper"

class ItemTest < ActiveSupport::TestCase
  test "slot is required and must be valid" do
    item = Item.new(name: "X", slot: "invalid_slot")
    refute item.valid?
    assert item.errors[:slot].present?
  end

  test "valid slots include common equipment types" do
    Item::SLOTS.sample(5).each do |slot|
      assert Item.new(name: "Test", slot: slot).valid?, "slot #{slot} should be valid"
    end
  end

  test "slot label is localized" do
    assert_equal "Tête", items(:leather_hat).slot_label
    assert_equal "Arme (1 main)", items(:short_sword).slot_label
    assert_equal "Bouclier", items(:small_shield).slot_label
  end
end
