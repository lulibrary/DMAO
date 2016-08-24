Rails.application.routes.draw do

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
                   sessions: 'admin/dmao_users/sessions'
               }
  end

  namespace :admin do
    resources :institutions
  end

end
