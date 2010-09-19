$:.unshift File.expand_path("../lib", __FILE__)
require 'gemma'

#Gemma::Rakefile.from_gemspec_file 'gemma.gemspec'

Gemma::RakeTasks.with_gemspec_file 'gemma.gemspec' do |g|
  g.rdoc.use_gem_if_available = false
end

=begin

Gemma::RakeTasks.with_gemspec_file 'gemma.gemspec' do |g|
  g.rdoc.output = 'foo'
  g.rdoc.pre_rdoc do |t|
    # ...
  end
  g.rdoc.post_rdoc do |t|
    # ...
  end

  g.yard.output = 'foo'
  g.yard.options << '--shiny'

  g.rdoc_dev = Gemma::RakeTasks::RDoc.new(g, :rdoc_dev)
  g.rdoc_dev.options << '--private'
end

desc "docs to rubyforge"
task :publish_docs => :rdoc_sh do
  sh "rsync --archive --delete --verbose doc/* "\
     " jdleesmiller@rubyforge.org:/var/www/gforge-projects/relax4"
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'ext'
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available; you must: sudo gem install spicycode-rcov"
  end
end

require 'rake/clean'
CLEAN.include('ext/*.o', 'ext/mkmf.log', 'ext/Makefile')
CLOBBER.include('ext/*.so')

task :test => EXT
task :default => :test

=end

