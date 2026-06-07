class CombatService
  attr_reader :log

  def initialize(quest_progress)
    @progress = quest_progress
    @player = quest_progress.player
    @step = quest_progress.current_step
    @npc = @step.npc
    @log = []
  end

  def start!
    return if @progress.in_combat?
    @progress.update!(current_npc_health: @npc.max_health)
  end

  def player_attack!
    raise "Pas de combat en cours" unless @progress.in_combat?

    damage = @player.total_force
    new_npc_health = [ @progress.current_npc_health - damage, 0 ].max
    @progress.update!(current_npc_health: new_npc_health)
    @log << "#{@player.name} inflige #{damage} dégâts à #{@npc.name}."

    if new_npc_health.zero?
      @log << "#{@npc.name} est vaincu !"
      { outcome: :npc_defeated, log: @log }
    else
      npc_attack!
    end
  end

  def npc_attack!
    damage = @npc.force
    new_health = [ @player.current_health - damage, 0 ].max
    @player.update!(current_health: new_health)
    @log << "#{@npc.name} inflige #{damage} dégâts à #{@player.name}."

    if new_health.zero?
      @progress.update!(status: "gameover", current_npc_health: nil)
      @log << "#{@player.name} a été vaincu."
      { outcome: :player_defeated, log: @log }
    else
      { outcome: :ongoing, log: @log }
    end
  end

  def flee!
    return unless @progress.in_combat?
    @progress.update!(current_npc_health: nil)
    @log << "#{@player.name} fuit le combat."
    { outcome: :fled, log: @log }
  end
end
