module Gemma
  class RakeTasks
    #
    # Run an executable script in the bin folder; the load path is set according
    # to the +require_paths+ list in the gemspec.
    #
    # The script should be in the gemspec's +executables+ list; the first entry
    # (if any) in the list is used by default.
    #
    # To pass arguments to the script, you have to pass them as arguments to
    # the rake task. The syntax for quoting the arguments will depend on your
    # shell, but on bash it might look like:
    #
    #   rake run['foo --bar=baz --bat=hi']
    #
    class RunTasks < Plugin
      #
      # @param [Gem::Specification] gemspec
      #
      def initialize gemspec
        super(gemspec)

        # Defaults.
        @task_name = :run
        @program_name = gemspec.executables.first
        @ruby_args = ['-w', "-I#{gemspec.require_paths.join(':')}"]
      end

      #
      # Name of rake task used to run the executable; defaults to run.
      #
      # @return [Symbol]    
      # 
      attr_accessor :task_name

      #
      # Name of the executable (file in the bin directory) to run; defaults to
      # the first entry in the gemspec's +executables+ list, if any.
      #
      # @return [String, nil]
      # 
      attr_accessor :program_name

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
        if program_name
          desc "run #{program_name}"
          task task_name, :args do |t, args|
            args = args[:args].split(/\s/)
            ruby(*(ruby_args + ["bin/#{program_name}"] + args))
          end
        end
        nil
      end
    end
  end
end

