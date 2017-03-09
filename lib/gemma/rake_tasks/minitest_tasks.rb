# frozen_string_literal: true
module Gemma
  class RakeTasks
    #
    # Create tasks to run minitest tests. By default, the +require_paths+ from
    # the gemspec and the gem's +test+ directory are placed on the load path,
    # and the +test_files+ given in the gemspec are executed as tests.
    #
    # Minitest works on both 1.8 and 1.9, and it's mostly compatible with 
    # <tt>Test::Unit</tt> tests.
    #
    # This plugin is based on the `Rake::TestTask` that comes bundled with rake.
    # If you need an option that isn't exposed by the plugin, you can modify the
    # `TestTask` object directly in a block passed to {#with_test_task}. 
    #
    class MinitestTasks < Plugin
      #
      # @param [Gem::Specification] gemspec
      #
      def initialize gemspec
        super(gemspec)

        # Defaults.
        @task_name = :test
        @files = gemspec.test_files.dup
        @with_test_task = nil
      end

      #
      # Name of rake task used to run the test; defaults to test.
      #
      # @return [Symbol]    
      # 
      attr_accessor :task_name

      #
      # The files to test; defaults to the +test_files+ from the gemspec.
      #
      # @return [Array<String>]    
      # 
      attr_accessor :files

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
        unless self.files.empty?
          require 'rake/testtask'
          Rake::TestTask.new(self.task_name) do |tt|
            tt.libs        = gemspec.require_paths.dup
            tt.libs       << 'test'
            tt.test_files  = self.files
            tt.ruby_opts  << '-rubygems' << '-rbundler/setup'
            @with_test_task.call(tt) if @with_test_task
          end
        end
        nil
      end
    end
  end
end
