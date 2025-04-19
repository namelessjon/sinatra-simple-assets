#!/usr/bin/env ruby

# Based on https://github.com/josh/ruby-coffee-script

require 'pathname'

module Sinatra
  module SimpleAssets
    class Handlebars
      class << self
        def precompile(*args)
          context.call('Handlebars.precompile', *args)
        end

        def wrap(scripts)
          ret = []
          ret << <<-eos
          Handlebars.templates = Handlebars.templates || {};
          (function (template, templates) {
          eos
          scripts.each do |name, source|
            ret << "templates['#{name}'] = template(#{precompile(source)});"
          end
          ret << <<-eos
          })(Handlebars.template, Handlebars.templates);
          eos
          ret.join("\n")
        end

        private

        def context
          require 'execjs'
          @context ||= ExecJS.compile(source)
        end

        def source
          @source ||= path.read
        end

        def path
          require 'handlebars/source'
          @path ||= Handlebars::Source.bundled_path
        end
      end
    end
  end
end
