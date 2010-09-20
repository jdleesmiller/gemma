module Gemma
  class RakeTasks
    #
    # Create tasks to generate documentation with yard (yardoc) if it is
    # available.
    #
    # The files to document are extracted from the gemspec's `files` and
    # `extra_rdoc_files` members.
    #
    # Unfortunately, yardoc's command line options are largely incompatible with
    # those for rdoc, but the `--main` and `--title` options from `rdoc_options`
    # are also passed through to yardoc by default. The short forms `-m` and
    # `-t` of these arguments are also passed on as `--main` and `--title` to
    # yardoc (note that `-m` and `-t` mean different things to yardoc than to
    # rdoc!). Note that any files (that is, non-options) in `rdoc_options` are
    # also ignored.
    #
    # If you want to further customize your yardoc output, you can add options
    # in the {Gemma::RakeTasks.with_gemspec_file} configuration block.
    #
    # This plugin is based on the `YARD::Rake::YardocTask` that comes bundled
    # with yard.  If you need an option that isn't exposed by the plugin, you
    # can modify the `YardocTask` object directly in a block passed to
    # {#with_yardoc_task}. 
    #
    class YardTasks < Plugin
      #
      # @param [Gem::Specification] gemspec
      #
      def initialize gemspec
        super(gemspec)

        # Defaults.
        @task_name = :yard
        @output = 'yard'
        @with_yardoc_task = nil

        # Extract supported rdoc options and add to the default yard options.
        # Keep track of main, if it is given, because we have to remove it from
        # the extra files list (otherwise it shows up twice in the output).
        @main = Options.extract(%w(-m --main), gemspec.rdoc_options).argument
        @title = Options.extract(%w(-t --title), gemspec.rdoc_options).argument

        @options = []

        # Don't document the test files.
        # Yard splits up the ruby files from the 'extra' files.
        @files = gemspec.files - gemspec.test_files - gemspec.extra_rdoc_files
        @extra_files = gemspec.extra_rdoc_files.dup
        @extra_files.delete(main) if main
      end

      #
      # Name of rake task used to generate these docs; defaults to yard.
      #
      # @return [Symbol] 
      #
      attr_accessor :task_name

      #
      # Name of output directory (the yard option --output); defaults to yard.
      #
      # @return [String] 
      #
      attr_accessor :output

      #
      # Name of file to display in index.html (the yard option --main);
      # extracted from gemspec; defaults to nil (none).
      #
      # @return [String, nil] 
      #
      attr_accessor :main

      #
      # Title for HTML output (the yard option --title); extracted from gemspec;
      # defaults to nil (unspecified).
      #
      # @return [String, nil] 
      #
      attr_accessor :title

      #
      # Ruby files to be processed by yard; these are extracted from the
      # gemspec; test files are not included by default.
      #
      # @return [Array<String>] 
      #
      attr_accessor :files

      #
      # Extra files (e.g. FAQ, LICENSE) to be processed by yard; these are
      # extracted from the gemspec.
      #
      # @return [Array<String>] 
      #
      attr_accessor :extra_files

      #
      # Options to be passed to yard; note that the {#output} option and the
      # {#files} and {#extra_files} lists are handled separately.
      #
      # @return [Array<String>]
      #
      attr_accessor :options

      #
      # Customize the yardoc task (e.g. to add blocks to run before or after the
      # docs are generated).
      #
      # @yield [yd] called after the defaults are set but before the yard task
      # is generated
      #
      # @yieldparam [YARD::Rake::YardocTask] yd
      #
      # @return [nil]
      #
      def with_yardoc_task &block
        @with_yardoc_task = block
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
          require 'yard'
          yd = YARD::Rake::YardocTask.new do |yd|
            yd.name    = self.task_name
            yd.options = complete_options
            yd.files   = self.files
            yd.files.push('-', *self.extra_files) unless self.extra_files.empty?
            @with_yardoc_task.call(yd) if @with_yardoc_task
          end
          CLOBBER.include(self.output)
          CLOBBER.include('.yardoc')
        rescue LoadError
          # Assume yard is not installed.
        end
        nil
      end

      private 

      # 
      # Options to be passed to yardoc; this includes {#options} and the
      # {#main}, {#title} and {#output} options.
      #
      # @return [Array<String>]
      # 
      def complete_options
        opts = self.options.dup
        opts.push('--main', self.main) if self.main
        opts.push('--title', self.title) if self.title
        opts.push('--output', self.output)
        opts
      end
    end
  end
end
