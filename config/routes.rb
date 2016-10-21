Rails.application.routes.draw do

  devise_for :institution_users, skip: :all, class_name: "Institution::User"
  devise_for :institution_admins, skip: :all, class_name: "Institution::Admin"

  root to: redirect('https://lulibrary.github.io/DMAO')
  
  post '/institution-login', to: 'pages#institution_login', as: :institution_login_selection

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
      resources :ingest_jobs, controller: 'institutions/ingest_jobs'
    end
    get '/', to: 'dashboard#dashboard', as: :dashboard
  end

  scope '/:institution_identifier', module: 'institutions' do

    devise_for :institution_admins,
               class_name: "Institution::Admin",
               path: '',
               path_names: {
                   sign_in: 'login',
                   sign_out: 'logout',
                   password: 'reset_password',
                   unlock: 'unlock'
               },
               controllers: {
                   sessions: 'institutions/admin/sessions',
                   passwords: 'institutions/admin/passwords',
                   unlocks: 'institutions/admin/unlocks'
               }

  end

  devise_scope :institution_admins do

    scope '/:institution_identifier', module: 'institutions', as: :institution do

      resources :users

      get '/', to: 'dashboard#dashboard', as: :dashboard

    end

  end

  namespace :api do
    namespace :v1 do

      resources :organisation_units, except: [:new, :edit]

    end
  end

end
