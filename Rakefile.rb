require 'rubygems'
require 'bundler/setup'
require 'gemma'

Gemma::RakeTasks.with_gemspec_file 'gemma.gemspec' do |g|
  # Yardoc does a nice job on everything but this script; it tries to process it
  # as an rdoc file, rather than as a ruby source file.
  g.yard.extra_files.delete('bin/gemma')

  # Some tests are hard to do once the gem is installed (i.e. they would cause
  # gem check gemma --test to fail); do these here. 
  #g.test.files << 'test/test_gemma_dev.rb'
end

task :default => :test

CLOBBER << 'test/my_new_gem_base'
CLOBBER << 'test/my_new_gem_full'

desc "docs to rubyforge"
task :publish_docs => :yard do
  sh "rsync --archive --delete --verbose yard/* "\
     " jdleesmiller@rubyforge.org:/var/www/gforge-projects/gemma"
end
