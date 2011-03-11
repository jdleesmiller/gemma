module Gemma
  class RakeTasks
    #
    # Run an executable script in the bin folder. 
    #
    # There is one task per entry in the gemspec's +executables+ list.
    # By default, warnings are enabled, the load path is set according to the
    # +require_paths+ in the gemspec, and rubygems is included.
    #
    # To pass arguments to the script, you have to pass them as arguments to
    # the rake task. The syntax for quoting the arguments will depend on your
    # shell, but on bash it might look like:
    #
    #   rake my_prog['foo --bar=baz --bat=hi']
    #
    class RunTasks < Plugin
      #
      # @param [Gem::Specification] gemspec
      #
      def initialize gemspec
        super(gemspec)

        # Defaults.
        @task_prefix = ''
        @program_names = gemspec.executables.dup
        @ruby_args = ['-w', "-I#{gemspec.require_paths.join(':')}", '-rubygems']
      end

      #
      # The task names are formed by prepending this string onto each program
      # name; defaults to the empty string.
      #
      # @return [String]    
      # 
      attr_accessor :task_prefix

      #
      # Names of the executable (file in the bin directory) to run; by default,
      # contains the +executables+ from the gemspec.
      #
      # @return [Array<String>] may be empty
      # 
      attr_accessor :program_names

      #
      # Arguments to be passed to ruby; by default, warnings are enabled (-w)
      # and the gemspec's +require_paths+ are on the load path (-I).
      #
      # @return [Array<String>]
      #
      attr_accessor :ruby_args

      #
      # Internal method; see {Plugin#create_rake_tasks}.
      #
      # @return [nil]
      #
      # @private
      #
      def create_rake_tasks
        program_names.each do |program_name|
          desc "run #{program_name}"
          task((task_prefix + program_name), :args) do |t, args|
            args = (args[:args] || '').split(/\s/)
            ruby(*(ruby_args + ["bin/#{program_name}"] + args))
          end
        end
        nil
      end
    end
  end
end

