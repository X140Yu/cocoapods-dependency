lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-dependency/version'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-dependency'
  spec.version       = CocoapodsDependency::VERSION
  spec.authors       = ['Xinyu Zhao']
  spec.email         = ['zhaoxinyu1994@gmail.com']

  spec.summary       = 'Analyzes the dependencies of any cocoapods projects.'
  spec.description   = 'Analyzes the dependencies of any cocoapods projects. Subspecs are properly handled.'
  spec.homepage      = 'https://github.com/X140Yu/cocoapods-dependency'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'coveralls', '~> 0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_dependency 'cocoapods', '~> 1.5'
end
