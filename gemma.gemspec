lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'gemma/version'

Gem::Specification.new do |s|
  s.name        = "gemma"
  s.version     = Gemma::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Lees-Miller"]
  s.email       = ["jdleesmiller@gmail.com"]
  s.homepage    = "http://github.com/jdleesmiller/gemma"
  s.summary     = "Gemspec-centric gem development helper."
  s.description = <<DESCRIPTION
Gemma is a gem development helper like hoe and jeweler, but it keeps the
gemspec in a gemspec file, where it belongs, instead of in your Rakefile.
This helps your gem to play nicely with commands like gem and bundle, and it
allows gemma to provide rake tasks with sensible defaults for many common gem
development tasks.
DESCRIPTION

  # TODO s.rubyforge_project = "gemma"

  s.add_dependency 'bundler',  '>= 1.0.7', '~> 1.0'
  s.add_dependency 'highline', '>= 1.6.1', '~> 1.6'
  
  s.files       = Dir.glob('{lib,bin}/**/*.rb') +
                  Dir.glob('template/**/*') + %w(README.rdoc)
  s.test_files  = Dir.glob('test/test_*.rb')
  s.executables = Dir.glob('bin/*').map{|f| File.basename(f)}

  s.rdoc_options = [
    "--main",    "README.rdoc",
    "--title",   "#{s.full_name} Documentation"]
  s.extra_rdoc_files = %w(README.rdoc bin/gemma)
end

