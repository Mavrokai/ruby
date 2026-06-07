class HomeController < ApplicationController
  def index
    redirect_to game_menu_path if signed_in?
  end
end
