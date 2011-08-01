Castle::Application.routes.draw do
  get 'ui' => 'main#ui'
  root :to => redirect('/ui')

  match 'player(/:action)' => 'players', :defaults => { :action => 'show' }
# match 'play'
# match 'pause'
# match 'volume'

  resources :tracks
end
