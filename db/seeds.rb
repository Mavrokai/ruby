puts "Seed: items..."
# Renommages pour coller à la planche « Équipements du projet : Steampunk / Guerre mythique »
{
  "Tricorne du contrebandier" => "Tricorne de contrebandier",
  "Heaume du gardien" => "Heaume de gardien"
}.each do |old_name, new_name|
  next unless (rec = Item.find_by(name: old_name))
  next if Item.exists?(name: new_name)
  rec.update!(name: new_name)
end

items_data = [
  # --- Quête intro (récompenses compatibles) ---
  { name: "Chapeau de cuir", slot: "hat", force_bonus: 0, health_bonus: 2, xp_bonus: 0 },
  { name: "Épée courte", slot: "weapon", force_bonus: 3, health_bonus: 0, xp_bonus: 0 },
  { name: "Petit bouclier", slot: "shield", force_bonus: 0, health_bonus: 3, xp_bonus: 0 },

  # --- Chapeaux / tête ---
  { name: "Barrette du sage", slot: "hat", force_bonus: 0, health_bonus: 1, xp_bonus: 2 },
  { name: "Calotte du moine", slot: "hat", force_bonus: 0, health_bonus: 2, xp_bonus: 1 },
  { name: "Tricorne de contrebandier", slot: "hat", force_bonus: 1, health_bonus: 0, xp_bonus: 1 },
  { name: "Heaume de gardien", slot: "hat", force_bonus: 2, health_bonus: 6, xp_bonus: 0 },
  { name: "Beret du barde", slot: "hat", force_bonus: 1, health_bonus: 2, xp_bonus: 2 },
  { name: "Casque d'acier", slot: "hat", force_bonus: 1, health_bonus: 4, xp_bonus: 0 },
  { name: "Diadème mystique", slot: "hat", force_bonus: 0, health_bonus: 0, xp_bonus: 3 },

  # --- Capes / dos ---
  { name: "Cape de velours", slot: "cape", force_bonus: 0, health_bonus: 3, xp_bonus: 0 },
  { name: "Manteau fourré", slot: "cape", force_bonus: 0, health_bonus: 5, xp_bonus: 0 },
  { name: "Cape du voyageur", slot: "cape", force_bonus: 1, health_bonus: 2, xp_bonus: 1 },
  { name: "Surcot brodé", slot: "cape", force_bonus: 1, health_bonus: 4, xp_bonus: 0 },
  { name: "Cape éclipsée", slot: "cape", force_bonus: 0, health_bonus: 2, xp_bonus: 3 },

  # --- Armures / torse ---
  { name: "Brigandine usée", slot: "chest", force_bonus: 1, health_bonus: 5, xp_bonus: 0 },
  { name: "Cotte de mailles", slot: "chest", force_bonus: 2, health_bonus: 8, xp_bonus: 0 },
  { name: "Cuirasse gravée", slot: "chest", force_bonus: 3, health_bonus: 10, xp_bonus: 0 },
  { name: "Gambison renforcé", slot: "chest", force_bonus: 1, health_bonus: 6, xp_bonus: 0 },
  { name: "Robe de l'archimage", slot: "chest", force_bonus: 0, health_bonus: 4, xp_bonus: 4 },

  # --- Armes proches (1 main) ---
  { name: "Épée de fer noir", slot: "weapon", force_bonus: 4, health_bonus: 0, xp_bonus: 0 },
  { name: "Rapière du dueliste", slot: "weapon", force_bonus: 3, health_bonus: 0, xp_bonus: 1 },
  { name: "Hache des brumes", slot: "weapon", force_bonus: 5, health_bonus: -1, xp_bonus: 0 },
  { name: "Dague serpent", slot: "weapon", force_bonus: 2, health_bonus: 0, xp_bonus: 2 },
  { name: "Marteau du juge", slot: "weapon", force_bonus: 4, health_bonus: 0, xp_bonus: 0 },

  # --- Armes à deux mains ---
  { name: "Claymore du nord", slot: "weapon_2h", force_bonus: 8, health_bonus: -2, xp_bonus: 0 },
  { name: "Hallebarde de garde", slot: "weapon_2h", force_bonus: 7, health_bonus: 0, xp_bonus: 0 },
  { name: "Lance du tournoi", slot: "weapon_2h", force_bonus: 6, health_bonus: 0, xp_bonus: 0 },
  { name: "Arc du vent", slot: "weapon_2h", force_bonus: 5, health_bonus: 0, xp_bonus: 2 },
  { name: "Lame dentelée", slot: "weapon_2h", force_bonus: 7, health_bonus: 0, xp_bonus: 0 },
  { name: "Épée à engrenages", slot: "weapon_2h", force_bonus: 6, health_bonus: 0, xp_bonus: 1 },
  { name: "Hache à deux mains", slot: "weapon_2h", force_bonus: 6, health_bonus: -2, xp_bonus: 0 },

  # --- Bâtons / magie ---
  { name: "Bâton d'éveil", slot: "staff", force_bonus: 1, health_bonus: 0, xp_bonus: 3 },
  { name: "Sceptre de cristal", slot: "staff", force_bonus: 0, health_bonus: 0, xp_bonus: 4 },
  { name: "Canne du prophète", slot: "staff", force_bonus: 1, health_bonus: 2, xp_bonus: 2 },
  { name: "Bâton racinaire", slot: "staff", force_bonus: 2, health_bonus: 0, xp_bonus: 3 },

  # --- Boucliers ---
  { name: "Rondache légère", slot: "shield", force_bonus: 0, health_bonus: 2, xp_bonus: 0 },
  { name: "Pavois de garnison", slot: "shield", force_bonus: 0, health_bonus: 6, xp_bonus: 0 },
  { name: "Écu gravé", slot: "shield", force_bonus: 1, health_bonus: 4, xp_bonus: 0 },
  { name: "Targe du berserker", slot: "shield", force_bonus: 2, health_bonus: 3, xp_bonus: 0 },
  { name: "Égide d'argent", slot: "shield", force_bonus: 1, health_bonus: 4, xp_bonus: 1 },

  # --- Jambières ---
  { name: "Braies de paysan", slot: "legs", force_bonus: 0, health_bonus: 2, xp_bonus: 0 },
  { name: "Pantalon de cuir", slot: "legs", force_bonus: 0, health_bonus: 3, xp_bonus: 0 },
  { name: "Jambières rivetées", slot: "legs", force_bonus: 1, health_bonus: 5, xp_bonus: 0 },
  { name: "Cuissardes polies", slot: "legs", force_bonus: 2, health_bonus: 6, xp_bonus: 0 },

  # --- Bottes ---
  { name: "Bottes de marcheur", slot: "boots", force_bonus: 0, health_bonus: 2, xp_bonus: 1 },
  { name: "Solerets étincelants", slot: "boots", force_bonus: 1, health_bonus: 4, xp_bonus: 0 },
  { name: "Bottines silencieuses", slot: "boots", force_bonus: 1, health_bonus: 1, xp_bonus: 2 },
  { name: "Sandales du pèlerin", slot: "boots", force_bonus: 0, health_bonus: 3, xp_bonus: 0 },

  # --- Gants ---
  { name: "Gants de voleur", slot: "gloves", force_bonus: 1, health_bonus: 0, xp_bonus: 1 },
  { name: "Gantelets du champion", slot: "gloves", force_bonus: 2, health_bonus: 3, xp_bonus: 0 },
  { name: "Mitaines du tireur d'arc", slot: "gloves", force_bonus: 2, health_bonus: 0, xp_bonus: 1 },

  # --- Ceinture / accessoires (planche : ceinture à poches + baudrier + amulette + anneaux) ---
  { name: "Anneau du coste", slot: "belt", force_bonus: 0, health_bonus: 2, xp_bonus: 1 },
  { name: "Ceinture à poches", slot: "belt", force_bonus: 0, health_bonus: 1, xp_bonus: 1 },
  { name: "Baudrier du ranger", slot: "belt", force_bonus: 1, health_bonus: 2, xp_bonus: 1 },
  { name: "Amulette du protecteur", slot: "belt", force_bonus: 0, health_bonus: 4, xp_bonus: 1 },
  { name: "Anneau du croc", slot: "belt", force_bonus: 3, health_bonus: 0, xp_bonus: 0 }
]

items_data.each do |attrs|
  Item.find_or_initialize_by(name: attrs[:name]).tap do |item|
    item.assign_attributes(attrs)
    item.save!
  end
end

puts "Seed: PNJ..."
npcs = [
  { name: "Gobelin éclaireur", max_health: 8,  force: 3 },
  { name: "Brigand des bois",  max_health: 14, force: 5 },
  { name: "Troll de pierre",   max_health: 24, force: 7 },
  { name: "Sorcière des marais", max_health: 18, force: 8 },
  { name: "Dragonnet",         max_health: 32, force: 10 }
]
npcs.each { |attrs| Npc.find_or_create_by!(name: attrs[:name]) { |n| n.assign_attributes(attrs) } }

puts "Seed: Quête de découverte..."
quest = Quest.find_or_create_by!(title: "Les Bois de Brumelune") do |q|
  q.description = "Aidez le village voisin à repousser les créatures qui menacent les marchands."
  q.final_xp_reward = 60
end
quest.update!(reward_items: Item.where(name: [ "Chapeau de cuir", "Épée courte", "Petit bouclier" ]))

[
  {
    position: 1,
    npc: Npc.find_by(name: "Gobelin éclaireur"),
    riddle_question: "Sans bouche je parle, sans oreilles j'entends. Qui suis-je ?",
    step_xp_reward: 10,
    answers: [ [ "Un écho", true ], [ "Un fantôme", false ], [ "Un livre", false ] ]
  },
  {
    position: 2,
    npc: Npc.find_by(name: "Brigand des bois"),
    riddle_question: "Plus on en prend, plus on en laisse derrière soi. Qu'est-ce ?",
    step_xp_reward: 15,
    answers: [ [ "Des pas", true ], [ "De l'eau", false ], [ "Des secrets", false ], [ "Du temps", false ] ]
  },
  {
    position: 3,
    npc: Npc.find_by(name: "Troll de pierre"),
    riddle_question: "Je grandis sans racines, je vole sans ailes. Qui suis-je ?",
    step_xp_reward: 20,
    answers: [ [ "Une montagne", false ], [ "Une rumeur", true ], [ "Le feu", false ] ]
  }
].each do |step_attrs|
  step = quest.quest_steps.find_or_initialize_by(position: step_attrs[:position])
  step.assign_attributes(
    npc: step_attrs[:npc],
    riddle_question: step_attrs[:riddle_question],
    step_xp_reward: step_attrs[:step_xp_reward]
  )
  step.answers.clear if step.persisted?
  step_attrs[:answers].each do |content, correct|
    step.answers.build(content: content, correct: correct)
  end
  step.save!
end

puts "Seed: boutique de l'hôtel des ventes..."
# Prix indicatif basé sur la puissance globale de l'objet.
shop_stock = {
  "Chapeau de cuir"        => 15,
  "Épée courte"            => 25,
  "Petit bouclier"         => 20,
  "Casque d'acier"         => 40,
  "Cotte de mailles"       => 80,
  "Épée de fer noir"       => 60,
  "Rondache légère"        => 18,
  "Bottes de marcheur"     => 22,
  "Gants de voleur"        => 20,
  "Cape de velours"        => 30,
  "Sceptre de cristal"     => 70
}
shop_stock.each do |item_name, price|
  item = Item.find_by(name: item_name)
  next unless item
  listing = MarketListing.shop.active.find_or_initialize_by(item: item)
  listing.assign_attributes(price: price, seller: nil, status: "active")
  listing.save!
end

puts "Seed terminé (#{Item.count} objets, #{MarketListing.shop.active.count} en boutique)."
