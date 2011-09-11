source :rubygems

# core
rails_ver = '~> 3.1.0'
gem 'railties',       rails_ver
gem 'actionpack',     rails_ver, require: %w(action_controller/railtie)
gem 'activesupport',  rails_ver, require: %w(active_support/railtie)
gem 'actionmailer',   rails_ver, require: %w(action_mailer/railtie)
gem 'activeresource', rails_ver
gem 'rails3-generators'

# I/O
gem 'eventmachine', '= 0.12.10'   # must be same as Heroku
gem 'em-http-request'
gem 'em-synchrony', require: %w(em-synchrony em-synchrony/em-http), git: 'https://github.com/RailsPlay/em-synchrony.git'
gem 'rack-fiber_pool', require: 'rack/fiber_pool'

# database
gem 'couchrest_model'

# asset template engines
group :assets do
  gem 'coffee-rails', '~> 3.1.0.rc'
  gem 'coffee-filter'
  gem 'haml-rails'
  gem 'json'
  gem 'sass-rails',  git: 'https://github.com/rails/sass-rails.git', branch: '3-1-stable'
  gem 'uglifier'
end

# other
gem 'active_reload'
gem 'compass', git: 'https://github.com/chriseppstein/compass.git', branch: 'rails31'
gem 'mplayer', path: '/home/steve/src/ruby-mplayer' #git: 'https://github.com/CodeMonkeySteve/ruby-mplayer.git'
gem 'rack-openid', :require => 'rack/openid'
gem 'ruby-ogginfo',   require: false,       git: 'https://github.com/CodeMonkeySteve/ruby-ogginfo.git'
gem 'ruby-audioinfo', require: 'audioinfo', git: 'https://github.com/CodeMonkeySteve/ruby-audioinfo.git' #path: '/home/steve/src/forks/ruby-audioinfo
gem 'thin'

group :production do
  gem 'therubyracer', require: 'v8'
end

group :development do
  gem 'therubyracer', require: 'v8'

  gem 'rspec-rails'
  gem 'ruby-debug19', require: 'ruby-debug'
  gem 'ruby_parser'

  gem 'guard'
  gem 'guard-rspec'

  gem 'rspec'             # jasmine kludge
  gem 'rails', rails_ver  # jasmine kludge
  gem 'jasmine', '~> 1.1.0.rc3'
end

group :development_linux do
  gem 'rb-inotify', git: 'https://github.com/hron/rb-inotify.git', branch: 'fix-guard-crash-when-file-is-deleted-very-fast'
  gem 'libnotify'
end
group :development_darwin do
  gem 'rb-fsevent'
  gem 'growl'
end
group :development_win32 do
  gem 'rb-fchange'
  #gem 'rb-notifu'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails', git: 'https://github.com/thoughtbot/factory_girl_rails.git'
  gem 'rr'
  gem 'rspec-rails'
  gem 'turn', require: false
  gem 'webmock'
end

