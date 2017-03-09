# frozen_string_literal: true
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'gemma/version'

Gem::Specification.new do |s|
  s.name        = 'gemma'
  s.version     = Gemma::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['John Lees-Miller']
  s.email       = ['jdleesmiller@gmail.com']
  s.homepage    = 'http://github.com/jdleesmiller/gemma'
  s.summary     = 'A gem development tool that plays well with bundler.'
  s.description = <<DESCRIPTION
Gemma is a gem development helper like hoe and jeweler, but it keeps the gemspec
in a gemspec file, instead of in a Rakefile. This helps your gem to play nicely
with commands like gem and bundle, and it allows gemma to provide rake tasks
with sensible defaults for many common gem development tasks.
DESCRIPTION

  s.add_dependency 'highline', '>= 1.6.21'
  s.add_dependency 'rake',     '>= 10.2.2'
  s.add_dependency 'rdoc',     '>= 4.1.1'
  s.add_dependency 'yard',     '>= 0.8.7'
  s.add_dependency 'minitest', '>= 5.3.1'

  s.add_development_dependency 'open4', '~> 1.3.0'

  s.files       = Dir.glob('{lib,bin}/**/*.rb') +
                  Dir.glob('template/**/{.*,*}') + %w(README.rdoc)
  s.test_files  = Dir.glob('test/gemma/*_test.rb')
  # - %w(test/test_gemma_dev.rb)
  s.executables = Dir.glob('bin/*').map { |f| File.basename(f) }

  s.rdoc_options = [
    '--main',    'README.rdoc',
    '--title',   "#{s.full_name} Documentation"
  ]
  s.extra_rdoc_files = %w(README.rdoc bin/gemma)
end
