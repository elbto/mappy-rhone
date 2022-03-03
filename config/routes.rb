Rails.application.routes.draw do
  root to: 'pages#home'
  resources :communes, only: [:index], path: '/results' do
    get :geojson, on: :collection
  end
end
