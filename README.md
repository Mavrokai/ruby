# Mediaval RPG (Ruby on Rails)

Projet W-WEB-401 — RoR.

Application web où un maître du jeu crée des quêtes (étapes, énigmes, PNJ, objets) et où les joueurs créent un personnage, résolvent des énigmes ou combattent au tour par tour, gagnent de l'expérience, montent de niveau et s'équipent.

## Prérequis

- Ruby 3.2+
- Bundler 2.x
- Node.js 18+ et npm
- Paquets système : `ruby-dev build-essential libyaml-dev zlib1g-dev libssl-dev libreadline-dev libsqlite3-dev`

Sur Ubuntu/Debian :

```bash
sudo apt update
sudo apt install -y ruby-dev build-essential libyaml-dev zlib1g-dev libssl-dev libreadline-dev libsqlite3-dev
```

## Installation

```bash
bundle config set --local path vendor/bundle
bundle install
bin/rails db:prepare
bin/rails db:seed
```

## Lancer le serveur

```bash
bin/rails server
```

L'application est alors accessible sur http://localhost:3000.

## Tester

```bash
bin/rails test
```

## Organisation

- `app/models` : `Player`, `Quest`, `QuestStep`, `QuestStepAnswer`, `Npc`, `Item`, `InventoryItem`, `QuestProgress`, `QuestReward`.
- `app/services` : `CombatService` (combat tour par tour) et `QuestProgressService` (progression, XP, fin de quête).
- `app/controllers` : flux joueur (accueil, sélection, menu, inventaire, quête, combat, récompense, game over) + interface admin sous `Admin::`.
- `app/views/admin` : interface maître du jeu (quêtes, étapes, réponses, PNJ, objets, joueurs, parties en cours).

## Règles de jeu implémentées

- Niveau 1, Force 10, PV 10, 10 points à répartir au départ.
- Inventaire multi-emplacements + bonus/malus Force/PV/XP.
- Chaque étape : choix entre répondre à l'énigme ou combattre le PNJ (Force vs PV, tour par tour, joueur d'abord).
- Game over si le joueur tombe à 0 PV.
- XP par étape + gros XP en fin de quête, passage de niveau attribue de nouveaux points (non modifiables une fois alloués).
- Choix d'un objet parmi plusieurs en fin de quête.
- Maître du jeu peut tout configurer et consulter l'état des parties.

## Options de jeu implémentées

- **Customisation du look** : portrait et couleur de bannière du héros éditables à tout moment
  (`players#edit`), et image personnalisée par objet de l'inventaire (`InventoryItem#custom_image`).
- **Suivi des parties en temps réel** : le tableau de bord MJ (`admin/quest_progresses`) se met à
  jour automatiquement via Turbo Streams (broadcast depuis `QuestProgress` et `Player`).
- **Chat MJ ↔ joueur via les PNJ** : le maître du jeu discute avec un joueur en incarnant un PNJ
  (`ChatMessage`), messages diffusés en direct des deux côtés (Turbo Streams).
- **Monnaie et hôtel des ventes** : les héros gagnent de l'or (étapes + fin de quête), achètent à la
  boutique gérée par le MJ et se revendent des objets entre eux (`MarketListing`, `MarketService`).
