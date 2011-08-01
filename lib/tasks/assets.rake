namespace :assets do
  task :precompile do
    Pathname.glob(Rails.root+'public/assets/*')  do |path|
      next  unless path.to_s =~ /^(.+)-[0-9a-f]{32}(\.\w+)$/i
      path.rename($1+$2)
    end
  end
end
