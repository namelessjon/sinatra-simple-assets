# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = 'sinatra-simple-assets'
  s.version     = '0.0.7'
  s.authors     = ["Pete O'Grady", "Jonathan Stott"]
  s.email       = ['pete@peteogrady.com', 'jonathan.stott@gmail.com']
  s.homepage    = 'https://github.com/peteog/sinatra-simple-assets'
  s.summary     = %q{Asset minification and bundling for Sinatra}
  s.description = %q{Asset minification and bundling for Sinatra}

  s.files = %w{
    .gitignore
    Gemfile
    README.md
    Rakefile
    lib/sinatra/simple_assets.rb
    lib/sinatra/simple_assets/assets.rb
    lib/sinatra/simple_assets/bundle.rb
    lib/sinatra/simple_assets/handlebars.rb
    vendor/handlebars.js
    sinatra-simple-assets.gemspec
  }
  s.require_paths = ['lib']

  s.add_dependency 'cssmin'
  s.add_dependency 'sinatra'
  s.add_dependency 'uglifier'
end
