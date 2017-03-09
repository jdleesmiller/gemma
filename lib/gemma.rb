# frozen_string_literal: true
require 'English'
require 'shellwords'

require_relative 'gemma/version'
require_relative 'gemma/utility'
require_relative 'gemma/options'
require_relative 'gemma/rake_tasks'

# Load default Rakefile plugins:
require_relative 'gemma/rake_tasks/plugin'
require_relative 'gemma/rake_tasks/rdoc_tasks'
require_relative 'gemma/rake_tasks/yard_tasks'
require_relative 'gemma/rake_tasks/minitest_tasks'
require_relative 'gemma/rake_tasks/gem_tasks'

require_relative 'gemma/conventions'
require_relative 'gemma/gem_from_template'
