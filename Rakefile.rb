$:.unshift File.expand_path("../lib", __FILE__)
require 'gemma'

Gemma::RakeTasks.with_gemspec_file 'gemma.gemspec' do |g|
  # g.rdoc.use_gem_if_available = false
end

task :default => :test

=begin
desc "docs to rubyforge"
task :publish_docs => :rdoc_sh do
  sh "rsync --archive --delete --verbose doc/* "\
     " jdleesmiller@rubyforge.org:/var/www/gforge-projects/relax4"
end
=end

