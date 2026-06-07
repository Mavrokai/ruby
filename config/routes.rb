Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  resources :players, only: [ :new, :create, :edit, :update ] do
    collection do
      get :select
      post :choose
      post :logout
    end
    member do
      get  :allocate_points
      post :spend_points
    end
  end

  scope "/game", as: :game do
    get  "/",            to: "game#menu",           as: :menu
    get  "/character",   to: "game#character",      as: :character
    get  "/inventory",   to: "game#inventory",      as: :inventory
    post "/equip/:inventory_item_id", to: "game#equip", as: :equip
    delete "/equip/:slot",            to: "game#unequip", as: :unequip
    post   "/customize/:inventory_item_id", to: "game#customize",   as: :customize_inventory
    delete "/customize/:inventory_item_id", to: "game#decustomize", as: :decustomize_inventory
  end

  resources :market_listings, only: [ :index, :new, :create, :destroy ] do
    member do
      post :buy
    end
  end

  resources :quests, only: [ :index, :show ] do
    member do
      post :start
    end
  end

  resources :quest_progresses, only: [ :show ] do
    member do
      post :answer
      post :start_combat
      post :attack
      post :flee
      get  :reward
      post :choose_reward
      get  :gameover
      post :retry
      post :send_message
    end
  end

  namespace :admin do
    root to: "dashboard#index"
    resources :players, only: [ :index, :show ]
    resources :quest_progresses, only: [ :index, :show ] do
      member do
        post :send_message
      end
    end
    resources :market_listings, only: [ :index, :new, :create, :destroy ]
    resources :quests do
      resources :quest_steps, except: [ :index ] do
        resources :quest_step_answers, except: [ :index, :show ]
      end
    end
    resources :npcs
    resources :items
  end
end
