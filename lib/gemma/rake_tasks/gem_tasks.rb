# frozen_string_literal: true
module Gemma
  class RakeTasks
    #
    # Create tasks for building and releasing gems.
    #
    # Note that the +release+ task is git-specific, but the other tasks are not
    # specific to any particular version control system.
    #
    # This plugin just calls <tt>Bundler::GemHelper</tt> with the given gemspec.
    #
    class GemTasks < Plugin
      #
      # @param [Gem::Specification] gemspec
      # @param [String, nil] gemspec_file_name
      #
      def initialize(gemspec, gemspec_file_name)
        super(gemspec)
        @gemspec_file_name = gemspec_file_name
      end

      #
      # Internal method; see {Plugin#create_rake_tasks}.
      #
      # @return [nil]
      #
      # @private
      #
      def create_rake_tasks
        require 'bundler/gem_helper'
        dir = File.dirname(@gemspec_file_name) if @gemspec_file_name
        Bundler::GemHelper.install_tasks(:dir => dir,
                                         :name => gemspec.name)
        nil
      end
    end
  end
end
