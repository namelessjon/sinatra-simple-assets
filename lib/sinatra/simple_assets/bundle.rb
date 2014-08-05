require 'digest/sha1'
module Sinatra
  module SimpleAssets
    class Bundle
      attr_accessor :files

      def initialize(name, root, asset_root, files)
        @name       = name
        @root       = root
        @asset_root = asset_root
        @files      = files
      end

      def type
        :txt
      end

      def inspect
        "#<#{self.class.name} @name=#{@name.inspect} @hash_name=#{hash_name}>"
      end

      def name
        "#{@name}.#{type}"
      end

      def hash_name
        "#{@name}-#{asset_hash}.#{type}"
      end

      def hashed_path
        "#{path}/#{hash_name}"
      end

      def asset_hash
        @asset_hash ||= Digest::SHA1.hexdigest(combined)
      end

      def content
        combined
      end

      def combined
        @combined ||= @files.map do |file|
          file_content(file)
        end.join("\n")
      end

      def file_content(file)
        File.read(@asset_root + file)
      rescue Errno::ENOENT
        File.read(@asset_root + file + ".#{type}")
      end

      def path
        type.to_s
      end

      def compile
        File.open("#{@root}/#{hashed_path}", 'w') do |f|
          f << content
        end
      end
    end
  end
end
