Rails.application.routes.draw do

  devise_for :institution_admins, skip: :all, class_name: "Institution::Admin"
  root to: 'pages#main'

  scope :admin do
    devise_for :dmao_admins,
               path: '',
               path_names: {
                   sign_in: 'login',
                   sign_out: 'logout',
                   password: 'reset_password',
                   unlock: 'unlock'
               },
               controllers: {
                   sessions: 'admin/dmao_admins/sessions',
                   passwords: 'admin/dmao_admins/passwords',
                   unlocks: 'admin/dmao_admins/unlocks'
               }
  end

  namespace :admin do
    resources :institutions do
      resources :admins, controller: 'institutions/admins'
    end
  end

end
