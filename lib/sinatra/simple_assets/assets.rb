require 'sinatra/simple_assets/js_bundle'
require 'sinatra/simple_assets/css_bundle'

module Sinatra
  module SimpleAssets
    class Assets
      def initialize(root, asset_root=root, &block)
        @root       = root
        @asset_root = asset_root
        @bundles    = {}
        @hashes     = {}
        configure(&block)
      end

      def configure(&block)
        instance_eval(&block) if block_given?
        self
      end

      def css(bundle, files)
        create_bundle(CssBundle, bundle, files)
      end

      def js(bundle, files)
        create_bundle(JsBundle, bundle, files)
      end

      def create_bundle(klass, name, files)
        bundle                      = klass.new(name, @root, @asset_root, files)
        @bundles[bundle.name]       = bundle
        @hashes[bundle.hash_name] = bundle
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
        b = @hashes[bundle] || @bundles[bundle]
        if b # if it's a full bundle, just return the content
          b.content
        else # otherwize, loop over all the bundles, looking.
          @bundles.values.lazy.map { |b| b.content_for(bundle) }.select { |c| !c.nil? }.first
        end
      end

      def precompile
        @bundles.values.each do |bundle|
          bundle.compile
        end
        self
      end

      def bundle_exists?(bundle)
        @hashes[bundle] || @bundles[bundle] 
      end

      def file_exists?(file)
        @bundles.values.lazy.select { |b| b.file_exist?(file) }.any?
      end
    end
  end
end
