$:.unshift File.expand_path("../lib", __FILE__)
require 'gemma'

Gemma::RakeTasks.with_gemspec_file 'gemma.gemspec' do |g|
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
