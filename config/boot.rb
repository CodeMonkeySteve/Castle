require 'rubygems'

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

# workaround for bug in Bundler: https://github.com/carlhuda/bundler/issues/1010
require 'yaml'
YAML::ENGINE.yamler = 'syck'

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
