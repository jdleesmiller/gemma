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
  s.summary     = "Generate helpful rake tasks from your gemspec."
  s.description = <<DESC
If you are using .gemspecs as intended
(http://yehudakatz.com/2010/04/02/using-gemspecs-as-intended/), gemma generates
common rake tasks with default settings extracted from your .gemspec file.
DESC

  # TODO s.rubyforge_project = "gemma"
  #s.add_dependency 'highline', 
  
  s.files        = Dir["{bin,lib}/**/*.rb"]
  s.test_files   = Dir["test/test_*.rb"]

  s.executables << 'gemma'

  s.rdoc_options = ['--main', 'README.rdoc']
  s.extra_rdoc_files << "README.rdoc"
end

