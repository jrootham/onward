Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pathways#new'
  resources :pathways, only: [:index, :show, :new]
  get 'search', to: 'search#index'
  get 'maesd_programs', to: 'search#maesd_programs'
end
