Rails.application.routes.draw do

  root to: 'pages#main'

  namespace :admin do
    resources :institutions
  end

end
