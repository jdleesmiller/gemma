# frozen_string_literal: true

require_relative 'lib/gemma/version'

Gem::Specification.new do |s|
  s.name        = 'gemma'
  s.version     = Gemma::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['John Lees-Miller']
  s.email       = ['jdleesmiller@gmail.com']
  s.homepage    = 'http://github.com/jdleesmiller/gemma'
  s.summary     = 'A gem development tool that plays well with bundler.'
  s.description = <<~DESCRIPTION
    Gemma is a gem development helper like hoe and jeweler, but it keeps the gemspec
    in a gemspec file, instead of in a Rakefile. This helps your gem to play nicely
    with commands like gem and bundle, and it allows gemma to provide rake tasks
    with sensible defaults for many common gem development tasks.
  DESCRIPTION
  s.required_ruby_version = '>= 3.0'
  s.metadata['rubygems_mfa_required'] = 'true'

  s.add_dependency 'getoptlong', '>= 0.2.1'
  s.add_dependency 'highline', '>= 1.6.21'
  s.add_dependency 'minitest', '>= 5.3.1'
  s.add_dependency 'rake',     '>= 10.2.2'
  s.add_dependency 'rdoc',     '>= 4.1.1'
  s.add_dependency 'rubocop',  '>= 0.42.0'
  s.add_dependency 'yard',     '>= 0.8.7'

  s.files       = Dir.glob('{lib,bin}/**/*.rb') +
                  Dir.glob('template/**/{.*,*}') + %w[README.md]
  s.test_files  = Dir.glob('test/gemma/*_test.rb')
  s.executables = Dir.glob('bin/*').map { |f| File.basename(f) }

  s.rdoc_options = [
    '--main',    'README.md',
    '--title',   "#{s.full_name} Documentation"
  ]
  s.extra_rdoc_files = %w[README.md bin/gemma]
end
