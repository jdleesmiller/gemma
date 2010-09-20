module Gemma
  class RakeTasks
    #
    # Create tasks to run test coverage using the built-in `rcov` tool. By
    # default, the `test_files` given in the gemspec are used to measure
    # coverage.
    #
    # This plugin is based on the `Rcov::RcovTask` that comes bundled with rcov.
    # If you need an option that isn't exposed by the plugin, you can modify the
    # `RcovTask` object directly in a block passed to {#with_rcov_task}. 
    #
    class RcovTasks < Plugin
      #
      # @param [Gem::Specification] gemspec
      #
      def initialize gemspec
        super(gemspec)

        # Defaults.
        @task_name = :rcov
        @output = 'rcov'
        @with_rcov_task = nil
      end

      #
      # Name of rake task; defaults to rcov.
      #
      # @return [Symbol]    
      # 
      attr_accessor :task_name

      #
      # Output directory for the XHTML report; defaults to rcov.
      #
      # @return [String] 
      #
      attr_accessor :output
   
      #
      # Customize the rcov task.
      #
      # @yield [rcov] called after the defaults are set but before the rcov task
      # is generated
      #
      # @yieldparam [Rcov::RcovTask] rcov
      #
      # @return [nil]
      #
      def with_rcov_task &block
        @with_rcov_task = block
        nil
      end

      #
      # Internal method; see {Plugin#create_rake_tasks}.
      #
      # @return [nil]
      #
      # @private
      #
      def create_rake_tasks 
        begin
          require 'rcov/rcovtask'
          Rcov::RcovTask.new(self.task_name) do |rcov|
            rcov.libs       = gemspec.require_paths
            rcov.test_files = gemspec.test_files
            rcov.warning    = true
            rcov.rcov_opts << "-x ^/"
            rcov.output_dir = self.output
            @with_rcov_task.call(rcov) if @with_rcov_task
          end
        rescue LoadError
          # Assume rcov is not installed.
        end
      end
    end
  end
end
