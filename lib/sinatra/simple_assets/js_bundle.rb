require 'sinatra/simple_assets/bundle'
require 'uglifier'
require 'sinatra/simple_assets/handlebars'

module Sinatra
  module SimpleAssets
    class JsBundle < Bundle
      attr_accessor :files

      def type
        :js
      end

      def content
        @content ||= Uglifier.new.compress combined_content
      end

      private

      def combined_content
        js, hbs = files.partition { |f| File.extname(f) == ".js" }

        "#{js_content(js)}\n#{hbs_content(hbs)}"
      end

      def js_content(files)
        files.map { |file| file_content(file) }.join("\n")
      end

      def hbs_content(files)
        # read in the file contents, and have the function names
        contents = *files.map { |file| [File.basename(file, ".hbs"), file_content(file)] }
        # Process the contents with handlebars, and wrap it in the nice wrapper for better minification
        Handlebars.wrap(Hash[contents])
      end
    end
  end
end
