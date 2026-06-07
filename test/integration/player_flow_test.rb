require "test_helper"

class PlayerFlowTest < ActionDispatch::IntegrationTest
  test "visitor can create a player and reach the menu" do
    get root_path
    assert_response :success

    get new_player_path
    assert_response :success

    assert_difference "Player.count", 1 do
      post players_path, params: { player: { name: "Aragorn" } }
    end
    follow_redirect!
    assert_response :success
    assert_match "Répartir vos points", response.body
  end

  test "menu requires a player" do
    get game_menu_path
    assert_redirected_to select_players_path
  end

  test "choose selects existing player" do
    player = players(:alice)
    post choose_players_path, params: { player_id: player.id }
    assert_redirected_to game_menu_path
    follow_redirect!
    assert_response :success
  end
end
