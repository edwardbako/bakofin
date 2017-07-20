Rails.application.routes.draw do

  resources :quotes, only: [:index]

  root to: 'welcome#index'
end
