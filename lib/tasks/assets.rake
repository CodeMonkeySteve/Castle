namespace :assets do
  task :precompile do
    dir = Pathname.new(File.join(Rails.public_path, Rails.application.config.assets.prefix))
    Pathname.glob(dir+'*')  do |path|
      next  unless path.to_s =~ /^(.+)-[0-9a-f]{32}(\.\w+)$/i
      path.rename($1+$2)
    end
  end
end
