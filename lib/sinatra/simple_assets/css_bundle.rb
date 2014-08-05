require 'sinatra/simple_assets/bundle'
require 'cssmin'
module Sinatra
  module SimpleAssets
    class CssBundle < Bundle
      attr_accessor :files

      def type
        :css
      end

      def content
        @content ||= CSSMin.minify combined
      end
    end
  end
end
