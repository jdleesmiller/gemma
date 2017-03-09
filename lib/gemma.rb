# frozen_string_literal: true
require 'English'
require 'shellwords'

require 'gemma/version'
require 'gemma/utility'
require 'gemma/options'
require 'gemma/rake_tasks'

# Load default Rakefile plugins:
require 'gemma/rake_tasks/plugin'
require 'gemma/rake_tasks/rdoc_tasks'
require 'gemma/rake_tasks/yard_tasks'
require 'gemma/rake_tasks/minitest_tasks'
require 'gemma/rake_tasks/gem_tasks'

require 'gemma/conventions'
require 'gemma/gem_from_template'
