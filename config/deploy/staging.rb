set :stage, :staging
set :rails_env, 'production'
server 'lib-dmao.lancs.ac.uk', user: 'deploy', roles: %w{web app db}
set :branch, 'master'
