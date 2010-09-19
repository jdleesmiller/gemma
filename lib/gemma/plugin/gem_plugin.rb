module Gemma
  #
  # Create tasks to build and release (push) gems.
  #
  class GemPlugin < Plugin
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
      if gemspec_file_name
        desc "gem build"
        task :build do
          sh "gem build #{gemspec_file_name}"
        end
         
        desc "gem release"
        task :release => :build do
          puts "gem push #{gemspec.file_name}"
        end

        desc "gem release"
        task :release => :build do
          puts "gem validate #{gemspec.file_name}"
        end
      end

      nil
    end
  end
end


