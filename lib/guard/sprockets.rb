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
      assets = Rails.application.config.assets.precompile

      # clear existing assets before rebuilding, in case of failure
      FileUtils.rm_f( assets.map { |a|  CompiledAssetDir+a } )

      success = begin
        Rails.application.assets.precompile(*assets)
        true
      rescue
        puts $!.message
        false
      end
      fix_asset_names

      notify( "Build #{success ? 'success' : 'failure'}", success )
    end

    def fix_asset_names
      Pathname.glob(CompiledAssetDir+'*')  do |path|
        next  unless path.to_s =~ /^(.+)-[0-9a-f]{32}(\.\w+)$/i
        path.rename($1+$2)
      end
    end

    def notify( msg, success )
      image, prio = success ? [:success, -2] : [:failed, 2]
      ::Guard::Notifier.notify( msg, :title => "Sprockets", :image => image, :priority => prio )
    end
  end
end

