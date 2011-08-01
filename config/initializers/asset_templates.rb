require 'jquery_template'
require 'tilt/haml'

Sprockets.register_engine '.haml', Tilt::HamlTemplate
Sprockets.register_engine '.jqt',  Tilt::JqueryTemplate
