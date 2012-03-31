require 'digest/sha1'
module Sinatra
  module SimpleAssets
    class Bundle
      attr_accessor :files

      def initialize(name, type, root, asset_root, files)
        @name       = name
        @type       = type
        @root       = root
        @asset_root = asset_root
        @files      = files
      end

      def name
        "#{@name}.#{@type}"
      end

      def hash_name
        "#{@name}-#{asset_hash}.#{@type}"
      end

      def hashed_path
        "#{path}/#{hash_name}"
      end

      def asset_hash
        @asset_hash ||= Digest::SHA1.hexdigest(combined)
      end

      def content
        case @type
        when :js
          require 'uglifier'
          @content ||= Uglifier.new.compress combined
        when :css
          require 'cssmin'
          @content ||= CSSMin.minify combined
        end
      end

      def combined
        @combined ||= @files.map do |file|
          File.open(@asset_root + file) { |f| f.read }
        end.join("\n")
      end

      def path
        @type.to_s
      end

      def compile
        File.open("#{@root}/#{hashed_path}", 'w') do |f|
          f << content
        end
      end
    end
  end
end
