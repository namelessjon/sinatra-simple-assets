require 'digest/sha1'
module Sinatra
  module SimpleAssets
    class Bundle
      attr_accessor :files

      def initialize(name, type, root, files)
        @name = name
        @type = type
        @root = root
        @files = files
      end

      def name
        "#{@name}.#{@type}"
      end

      def hash_name
        "#{@name}-#{hash}.#{@type}"
      end

      def hashed_path
        "#{path}/#{hash_name}"
      end

      def hash
        @hash ||= begin
                    Digest::SHA1.hexdigest content
                  rescue
                    # Find the most recent compressed version if the JS runtime is unavailable
                    fname = Dir.glob("#{@root}/#{path}/#{@name}-*.#{@type}").sort_by {|f| File.mtime(f)}.last
                    fname.split('-').last.sub(".#{@type}", "")
                  end
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
          File.open(@root + file) { |f| f.read }
        end.join("\n")
      end

      def path
        @type == :js ? 'javascripts' : 'stylesheets'
      end

      def compile
        File.open("#{@root}/#{hashed_path}", 'w') do |f|
          f << content
        end
      end
    end
  end
end
