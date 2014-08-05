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

    def assets(assets = nil, &block)
      @assets ||= (assets ? assets : Assets.new(self.public_folder, self.asset_root))
      @assets.configure(&block)
    end

    def self.registered(app)
      app.helpers SimpleAssets::Helpers

      app.set :asset_root, app.public_folder


      app.get "/js/views/:template" do |template|
        template = File.basename(template, ".hbs")
        path = File.join(app.asset_root, 'js', 'views', "#{template}.hbs")
        not_found unless File.file?(path)
        require 'sinatra/simple_assets/handlebars'
        content_type :js
        Handlebars.wrap(template => File.read(path))
      end

      [
        { :route => '/css', :type => :css },
        { :route => '/js', :type => :js },
        { :route => '/hbs', :type => :js }
      ].each do |r|
        app.get "#{r[:route]}/*" do |bundle|
          assets = settings.assets
          # full name of the file, if it's a file and not a bundle
          file_name = File.join(r[:route], bundle)

          if assets.bundle_exists?(bundle)
            etag bundle
          cache_control :public, :max_age => 2592000 # one month
          elsif assets.file_exists?(file_name)
            cache_control :public, :must_revalidate, :max_age => 0
          else
            not_found
          end


          content_type r[:type]
          assets.content_for(bundle) || assets.content_for(file_name)
        end
      end

    end
   end

  register SimpleAssets
end
