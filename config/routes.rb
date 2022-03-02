Rails.application.routes.draw do
  root to: 'pages#home'
  resources :communes, only: [:index], path: '/results'
end
