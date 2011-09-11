require 'jquery_template'
require 'tilt/haml'

Rails.application.assets.register_engine '.haml', Tilt::HamlTemplate
Rails.application.assets.register_engine '.jqt',  Tilt::JqueryTemplate
