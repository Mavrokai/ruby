class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  stale_when_importmap_changes

  helper_method :current_player, :signed_in?

  private

  def current_player
    @current_player ||= Player.find_by(id: session[:player_id]) if session[:player_id]
  end

  def signed_in?
    current_player.present?
  end

  def require_player!
    return if signed_in?
    redirect_to select_players_path, alert: "Choisissez d'abord un personnage."
  end
end
