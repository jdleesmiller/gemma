module Gemma
  class RakeTasks
    #
    # Create tasks to run Test::Unit tests using the built-in (standard library)
    # `test/unit`. By default, the `test_files` given in the gemspec are tested.
    #
    # This plugin is based on the `Rake::TestTask` that comes bundled with rake.
    # If you need an option that isn't exposed by the plugin, you can modify the
    # `TestTask` object directly in a block passed to {#with_test_task}. 
    #
    class TestUnitTasks < Plugin
      #
      # @param [Gem::Specification] gemspec
      #
      def initialize gemspec
        super(gemspec)

        # Defaults.
        @task_name = :test
        @with_test_task = nil
      end

      #
      # Name of rake task used to run the test; defaults to test.
      #
      # @return [Symbol]    
      # 
      attr_accessor :task_name

      #
      # Customize the test task.
      #
      # @yield [tt] called after the defaults are set but before the test task
      # is generated
      #
      # @yieldparam [Rake::TestTask] tt
      #
      # @return [nil]
      #
      def with_test_task &block
        @with_test_task = block
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
        require 'rake/testtask'
        Rake::TestTask.new(self.task_name) do |tt|
          tt.libs        = gemspec.require_paths
          tt.test_files  = gemspec.test_files
          tt.warning     = true
          @with_test_task.call(tt) if @with_test_task
        end
        nil
      end
    end
  end
end
