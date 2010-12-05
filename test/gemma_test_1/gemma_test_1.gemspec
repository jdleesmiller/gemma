# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
require 'gemma_test_1/version'
 
Gem::Specification.new do |s|
  s.name              = 'gemma_test_1'
  s.version           = GemmaTest1::VERSION
  s.platform          = Gem::Platform::RUBY
  s.authors           = ['John Lees-Miller']
  s.email             = ['jdleesmiler@gmail.com']
  s.homepage          = "http://github.com/jdleesmiller/gemma"
  s.summary           = %q{Test gem for gemma.}
  s.description       = %q{Test gem for gemma.}

  s.rubyforge_project = 'gemma_test_1'

  #s.add_runtime_dependency '...'
  s.add_development_dependency 'gemma', '~> 0.0'

  s.files       = Dir.glob('{lib,bin}/**/*.rb') + %w(README.rdoc)
  s.test_files  = Dir.glob('test/test_*.rb')
  s.executables = Dir.glob('bin/*').map{|f| File.basename(f)}

  s.rdoc_options = [
    "--main",    "README.rdoc",
    "--title",   "#{s.full_name} Documentation"]
  s.extra_rdoc_files << "README.rdoc"
end

