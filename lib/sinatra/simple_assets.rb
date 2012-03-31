require 'sinatra/base'
require 'sinatra/simple_assets/assets'

module Sinatra
  module SimpleAssets
    module Helpers
      def stylesheet(bundle)
        settings.assets.paths_for("#{bundle}.css", settings.environment).map do |file|
          "<link rel=\"stylesheet\" href=\"#{url(file)}\">"
        end.join("\n")
      end

      def javascript(bundle)
        settings.assets.paths_for("#{bundle}.js", settings.environment).map do |file|
          "<script src=\"#{url(file)}\"></script>"
        end.join("\n")
      end
    end

    def assets(&block)
      @assets ||= Assets.new(self.public_folder)
      @assets.configure(&block)
    end

    def self.registered(app)
      app.helpers SimpleAssets::Helpers

      [
        { :route => '/css', :type => :css },
        { :route => '/js', :type => :js }
      ].each do |r|
        app.get "#{r[:route]}/:bundle" do |bundle|
          assets = settings.assets

          if assets.bundle_exists?(bundle)
            etag bundle
          else
            not_found
          end

          cache_control :public, :max_age => 2592000 # one month

          content_type r[:type]
          assets.content_for(bundle)
        end
      end
    end
  end

  register SimpleAssets
end
