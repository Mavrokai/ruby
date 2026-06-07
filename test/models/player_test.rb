require "test_helper"

class PlayerTest < ActiveSupport::TestCase
  test "default starting stats match the spec" do
    player = Player.create!(name: "Boris")
    assert_equal Player::STARTING_LEVEL, player.level
    assert_equal Player::STARTING_FORCE, player.force
    assert_equal Player::STARTING_HEALTH, player.max_health
    assert_equal Player::STARTING_HEALTH, player.current_health
    assert_equal Player::STARTING_STAT_POINTS, player.available_stat_points
    assert_equal 0, player.experience
  end

  test "name is required and unique" do
    Player.create!(name: "Hero")
    duplicate = Player.new(name: "Hero")
    assert_not duplicate.valid?
    assert duplicate.errors[:name].present?
  end

  test "equipping items boosts total stats" do
    player = players(:alice)
    sword = items(:short_sword)
    shield = items(:small_shield)
    player.inventory_items.create!(item: sword)
    player.inventory_items.create!(item: shield)

    player.equip(sword)
    player.equip(shield)

    assert_equal 10 + 3, player.total_force
    assert_equal 10 + 3, player.total_max_health
  end

  test "cannot equip an item not owned" do
    player = players(:alice)
    sword = items(:short_sword)
    refute player.equip(sword)
  end

  test "gain_experience triggers level up and adds stat points" do
    player = players(:alice)
    player.update!(available_stat_points: 0)
    player.gain_experience(Player::XP_FOR_LEVEL + 30)
    assert_equal 2, player.level
    assert_equal 30, player.experience
    assert_equal Player::POINTS_PER_LEVEL, player.available_stat_points
  end

  test "spend_stat_points distributes between force and health" do
    player = players(:alice)
    assert player.spend_stat_points(force_points: 4, health_points: 6)
    assert_equal 10 + 4, player.force
    assert_equal 10 + 6, player.max_health
    assert_equal 0, player.available_stat_points
  end

  test "spend_stat_points rejects overspending" do
    player = players(:alice)
    refute player.spend_stat_points(force_points: 11, health_points: 0)
    assert_equal 10, player.available_stat_points
  end

  test "xp bonus from equipped item adds to step gain" do
    player = players(:alice)
    staff = items(:magic_staff)
    player.inventory_items.create!(item: staff)
    player.equip(staff)
    assert_equal 5, player.step_xp_bonus
  end
end
