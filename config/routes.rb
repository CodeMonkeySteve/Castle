Castle::Application.routes.draw do
  get 'ui' => 'main#ui'
  root to: redirect('/ui')

  match 'login',  to: 'users#login',  as: 'login'
  get   'logout', to: 'users#logout', as: 'logout'

  post 'tracks' => 'tracks#create', as: 'tracks'
  match 'player(/:action)' => 'players', defaults: { action: 'show' }
end
