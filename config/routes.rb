Rails.application.routes.draw do

  resources :quotes, only: [:index]
  resources :ticks, only: [:index]

  root to: 'welcome#index'
end
