class PlayersController < ApplicationController
  before_action :set_player, only: [ :allocate_points, :spend_points, :edit, :update ]

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    if @player.save
      session[:player_id] = @player.id
      redirect_to allocate_points_player_path(@player), notice: "Personnage créé. Répartissez vos points de départ."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def select
    @players = Player.order(:name)
  end

  def choose
    player = Player.find_by(id: params[:player_id])
    if player
      session[:player_id] = player.id
      redirect_to game_menu_path, notice: "Bienvenue, #{player.name} !"
    else
      redirect_to select_players_path, alert: "Personnage introuvable."
    end
  end

  def logout
    session.delete(:player_id)
    redirect_to root_path, notice: "Déconnecté."
  end

  def edit
  end

  def update
    if @player.update(customization_params)
      redirect_to game_character_path, notice: "Personnalisation enregistrée."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def allocate_points
    redirect_to game_menu_path if @player.available_stat_points.zero?
  end

  def spend_points
    if @player.spend_stat_points(force_points: params[:force_points], health_points: params[:health_points])
      if @player.available_stat_points.zero?
        redirect_to game_menu_path, notice: "Points attribués."
      else
        redirect_to allocate_points_player_path(@player), notice: "Points attribués."
      end
    else
      redirect_to allocate_points_player_path(@player), alert: "Répartition invalide."
    end
  end

  private

  def set_player
    @player = Player.find(params[:id])
    redirect_to root_path, alert: "Accès refusé." unless current_player&.id == @player.id
  end

  def player_params
    params.require(:player).permit(:name, :avatar)
  end

  def customization_params
    params.require(:player).permit(:name, :avatar, :accent_color)
  end
end
