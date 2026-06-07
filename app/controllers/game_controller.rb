class GameController < ApplicationController
  before_action :require_player!

  def menu
    @active_progress = current_player.active_quest_progress
  end

  def character
  end

  def inventory
    @inventory = current_player.inventory_items.includes(:item, custom_image_attachment: :blob)
    @inventory_by_item_id = @inventory.index_by(&:item_id)
  end

  def equip
    inventory_item = current_player.inventory_items.find_by(id: params[:inventory_item_id])
    if inventory_item && current_player.equip(inventory_item.item)
      redirect_to game_inventory_path, notice: "#{inventory_item.item.name} équipé."
    else
      redirect_to game_inventory_path, alert: "Impossible d'équiper cet objet."
    end
  end

  def unequip
    if current_player.unequip(params[:slot])
      redirect_to game_inventory_path, notice: "Objet retiré."
    else
      redirect_to game_inventory_path, alert: "Emplacement invalide."
    end
  end

  def customize
    inventory_item = current_player.inventory_items.find_by(id: params[:inventory_item_id])
    if inventory_item && params[:custom_image].present?
      inventory_item.custom_image.attach(params[:custom_image])
      redirect_to game_inventory_path, notice: "Apparence de #{inventory_item.name} personnalisée."
    else
      redirect_to game_inventory_path, alert: "Impossible de personnaliser cet objet."
    end
  end

  def decustomize
    inventory_item = current_player.inventory_items.find_by(id: params[:inventory_item_id])
    inventory_item&.custom_image&.purge_later
    redirect_to game_inventory_path, notice: "Apparence par défaut rétablie."
  end
end
