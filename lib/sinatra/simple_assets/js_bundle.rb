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
        combined  = []
        last_type = nil
        temp      = []

        files.each do |file|
          type = file_type(file)

          if type != last_type
            # if we have files, combine them and add them
            unless temp.empty?
              combined << combine_content(last_type, temp)
            end
            temp.clear
          end

          last_type = type
          temp      << file
        end
        combined << combine_content(last_type, temp)
        combined.join("\n")
      end

      def file_type(file)
        case File.extname(file)
        when '.js'
          :js
        when '.hbs'
          :hbs
        else
          raise "Unknown extension on '#{file}'"
        end
      end

      def combine_content(type, files)
        case type
        when :js
          js_content files
        when :hbs
          hbs_content files
        else
          raise "unknown type"
        end
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
