module Gemma
  class RakeTasks
    #
    # Create tasks to build and release (push) gems.
    #
    # TODO not done yet
    #
    class GemTasks < Plugin
      #
      # @param [Gem::Specification] gemspec
      # @param [String, nil] gemspec_file_name
      #
      def initialize gemspec, gemspec_file_name
        super(gemspec)

        @gemspec_file_name = gemspec_file_name

        # Defaults.
        @output = 'pkg'
      end

      #
      # Name of the gemspec file to be built; if this is nil, no gem tasks are
      # generated. 
      #
      # @return [String, nil] 
      #
      attr_accessor :gemspec_file_name

      #
      # Name of directory in which gem files are placed; defaults to pkg.
      #
      # @return [String]
      #
      attr_accessor :output

      #
      # Full path to gem file.
      #
      # @return [String]
      #
      def gem_file
        File.join(output, gemspec.file_name)
      end

      #
      # Internal method; see {Plugin#create_rake_tasks}.
      #
      # @return [nil]
      #
      # @private
      #
      def create_rake_tasks
        if gemspec_file_name
          directory output

          desc "gem build"
          task :build => output do
            sh "gem build #{gemspec_file_name}"
            mv gemspec.file_name, gem_file
          end
          CLOBBER.include(gem_file)
           
          desc "gem release"
          task :release => :build do
            sh "gem push #{gem_file}"
          end
        end

        nil
      end
    end
  end
end
