Rails.application.routes.draw do

  namespace :admin do
    resources :institutions
  end

end
