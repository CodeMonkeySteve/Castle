require 'guard/guard'
require 'fileutils'

module ::Guard
  class Sprockets < ::Guard::Guard
    CompiledAssetDir = Rails.root+'public/assets'

    def start
      run_all
    end

    def run_all
      UI.info "Rebuilding all assets"
      build_assets
      true
    end

    def run_on_change(paths)
      paths = paths.map { |p|  File.basename(p) } #.reject { |p|  p[0] == '.' }
      UI.info "Assets changed: #{paths.join(', ')}"
      build_assets
      true
    end

  protected
    def build_assets
      success = begin
        config = Rails.application.config
        env    = Rails.application.assets
        target = Pathname.new(File.join(Rails.public_path, config.assets.prefix))

        config.assets.precompile.each do |path|
          env.each_logical_path do |logical_path|
            if path.is_a?(Regexp)
              next unless path.match(logical_path)
            else
              next unless File.fnmatch(path.to_s, logical_path)
            end

            if asset = env.find_asset(logical_path)
              filename = target.join(File.basename(logical_path))
              FileUtils.mkdir_p filename.dirname
              asset.write_to(filename)
            end
          end
        end
        true
      rescue
        puts $!.message
        false
      end

      notify( "Build #{success ? 'success' : 'failure'}", success )
    end

    def notify( msg, success )
      image, prio = success ? [:success, -2] : [:failed, 2]
      ::Guard::Notifier.notify( msg, :title => "Sprockets", :image => image, :priority => prio )
    end
  end
end

