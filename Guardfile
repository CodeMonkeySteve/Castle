require File.dirname(__FILE__)+'/config/environment'

guard 'sprockets', :output => 'public/assets' do
  watch %r{^app/assets.+/[^\.][^/]+\.(js|css|sass)}
  watch %r{^spec/javascripts.+/[^\.][^/]+\.js}
end

guard 'rspec', all_after_pass: false, cli: '--color --format nested' do  # --fail-fast --drb
  watch(%r{(^|/)\.'}) {}  # ignore dot files
  watch('spec/spec_helper.rb')                       { "spec" }
  #watch('config/routes.rb')                          { "spec/routing" }
  watch('app/controllers/application_controller.rb') { "spec/controllers" }
  watch(%r{^spec/(.+)_spec\.rb})                     { |m| m[0] }
  watch(%r{^spec/factories/(.+)\.rb})                { "spec" }
  watch(%r{^app/(.+)\.rb})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb})  { |m|
    ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb"]
  }
end
