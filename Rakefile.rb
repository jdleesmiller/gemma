$:.unshift File.expand_path("../lib", __FILE__)
require 'rubygems'
require 'gemma'

Gemma::RakeTasks.with_gemspec_file 'gemma.gemspec' do |g|
  # Yardoc does a nice job on everything but this script; it tries to process it
  # as an rdoc file, rather than as a ruby source file.
  g.yard.extra_files.delete('bin/gemma')
end

task :default => :test

CLOBBER << 'test/my_new_gem_base'
CLOBBER << 'test/my_new_gem_full'

=begin
desc "docs to rubyforge"
task :publish_docs => :rdoc_sh do
  sh "rsync --archive --delete --verbose yard/* "\
     " jdleesmiller@rubyforge.org:/var/www/gforge-projects/gemma"
end
=end
