lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'gemma/version'

Gem::Specification.new do |s|
  s.name        = "gemma"
  s.version     = Gemma::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John Lees-Miller"]
  s.email       = ["jdleesmiller@gmail.com"]
  s.homepage    = "" # http://gemma.rubyforge.org/"
  s.summary     = "Generates common gem development rake tasks from your "\
                  "gemspec (not the other way around)."
  s.description = ""
  #s.rubyforge_project = "gemma"
  
  s.files        = Dir["lib/**/*.rb"]
  s.test_files   = Dir["test/test_*.rb"]

  s.add_development_dependency 'yard'

  s.rdoc_options = ['--main', 'README.rdoc']
  s.extra_rdoc_files << "README.rdoc"
end

