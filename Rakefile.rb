require 'rubygems'
require 'bundler/setup'
require 'gemma'

Gemma::RakeTasks.with_gemspec_file 'gemma.gemspec'

task :default => :test

desc "docs to rubyforge"
task :publish_docs => :yard do
  sh "rsync --archive --delete --verbose yard/* "\
     " jdleesmiller@rubyforge.org:/var/www/gforge-projects/gemma"
end

# note: to release:
# gem install rubyforge
# rubyforge setup
# rubyforge config
# rubyforge add_release gemma gemma 2.0.0 pkg/gemma-2.0.0.gem
