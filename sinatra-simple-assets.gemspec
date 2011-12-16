# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name        = 'sinatra-simple-assets'
  s.version     = '0.0.4'
  s.authors     = ["Pete O'Grady"]
  s.email       = ['pete@peteogrady.com']
  s.homepage    = 'https://github.com/peteog/sinatra-simple-assets'
  s.summary     = %q{Asset minification and bundling for Sinatra}
  s.description = %q{Asset minification and bundling for Sinatra}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'cssmin', '~> 1.0.2'
  s.add_dependency 'sinatra', '~> 1.3.0'
  s.add_dependency 'uglifier', '~> 1.2.0'
end
