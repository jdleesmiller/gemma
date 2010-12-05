require 'bundler'

module Gemma
  class RakeTasks
    #
    # Include bundler's tasks for building and releasing (pushing) gems.
    #
    class BundlerGemTasks < Plugin
      #
      # @param [Gem::Specification] gemspec
      # @param [String, nil] gemspec_file_name
      #
      def initialize gemspec, gemspec_file_name
        super(gemspec)

        @gemspec_file_name = gemspec_file_name
      end

      #
      # Name of the gemspec file to be built; if this is nil, no gem tasks are
      # generated. 
      #
      # @return [String, nil] 
      #
      attr_accessor :gemspec_file_name

      #
      # Internal method; see {Plugin#create_rake_tasks}.
      #
      # @return [nil]
      #
      # @private
      #
      def create_rake_tasks
        # Bundler::GemHelper does not work when Rake.application.rakefile is
        # nil, because it relies on Rake.application.rakefile_location.
        if gemspec_file_name && Rake.application.rakefile
          Bundler::GemHelper.install_tasks :name =>
            File.basename(gemspec_file_name, '.gemspec')
          CLOBBER.include('pkg')
        end
        nil
      end
    end
  end
end

