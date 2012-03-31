require 'sinatra/simple_assets/bundle'
module Sinatra
  module SimpleAssets
    class Assets
      def initialize(root, &block)
        @root    = root
        @bundles = {}
        @hashes  = {}
        configure(&block)
      end

      def configure(&block)
        instance_eval(&block) if block_given?
        self
      end

      def css(bundle, files)
        create_bundle(bundle, :css, files)
      end

      def js(bundle, files)
        create_bundle(bundle, :js, files)
      end

      def create_bundle(name, type, files)
        bundle                      = Bundle.new(name, type, @root, files)
        @bundles[bundle.name]       = bundle
        @hashes[bundle.hashed_path] = bundle
        self
      end

      def paths_for(bundle, environment = :development)
        bundle = @bundles[bundle]
        return [] unless bundle

        if environment == :production
          [bundle.hashed_path]
        else
          bundle.files
        end
      end

      def content_for(bundle)
        bundle = @hashes[bundle]
        bundle.content if bundle
      end

      def precompile
        @bundles.values.each do |bundle|
          bundle.compile
        end
        self
      end

      def bundle_exists?(bundle)
        @hashes[bundle]
      end
    end
  end
end
