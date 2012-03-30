require 'sinatra/simple_assets/bundle'
module Sinatra
  module SimpleAssets
    class Assets
      def initialize(root, &block)
        @root    = root
        @bundles = {}
        @hashes  = {}
        instance_eval(&block)
      end

      def css(bundle, files)
        create_bundle(bundle, :css, files)
      end

      def js(bundle, files)
        create_bundle(bundle, :js, files)
      end

      def create_bundle(name, type, files)
        bundle = Bundle.new(name, type, @root, files)
        @bundles[bundle.name] = bundle
      end

      def paths_for(bundle, environment = :development)
        bundle = @bundles[bundle]
        return [] unless bundle

        if environment == :production
          @hashes[bundle.hash_name] = bundle.name
          [bundle.hashed_path]
        else
          bundle.files
        end
      end

      def content_for(bundle)
        bundle = @bundles[@hashes[bundle]]
        bundle.content if bundle
      end

      def precompile
        @bundles.values.each do |bundle|
          bundle.compile
        end
      end

      def bundle_exists?(bundle)
        @hashes[bundle]
      end
    end
  end
end
