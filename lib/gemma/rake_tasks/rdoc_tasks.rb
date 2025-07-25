# frozen_string_literal: true

require 'rdoc/task'

module Gemma
  class RakeTasks
    #
    # Create tasks for generating +rdoc+ API documentation with settings from
    # the gemspec.
    #
    # The default settings are based on the +require_paths+, +rdoc_options+ and
    # +extra_rdoc_files+ data in the gemspec.
    #
    # This plugin is based on the <tt>Rake::RDocTask</tt> that comes bundled
    # with rdoc.  If you need an option that isn't exposed by the plugin, you
    # can modify the +RDocTask+ object directly in a block passed to
    # {#with_rdoc_task}.
    #
    class RDocTasks < Plugin
      #
      # @param [Gem::Specification] gemspec
      #
      def initialize(gemspec)
        super

        # Defaults.
        @task_name = :rdoc
        @with_rdoc_task = nil

        # I'm not sure whether it's a good idea to pass -o in the gemspec, but
        # for now we'll handle it, because it's needed in the Rakefile.
        @options = gemspec.rdoc_options
        @output, @options = Options.extract(%w[-o --output --op], @options).to_a
        @output ||= 'rdoc'

        # Extract --main, --title and --template so RDocTask can have them.
        @main, @options  = Options.extract(%w[-m --main], @options).to_a
        @title, @options = Options.extract(%w[-t --title], @options).to_a
        @template, @options = Options.extract(%w[-T --template], @options).to_a

        @files = gemspec.require_paths + gemspec.extra_rdoc_files
      end

      #
      # Name of rake task used to generate these docs; defaults to rdoc.
      #
      # @return [Symbol]
      #
      attr_accessor :task_name

      #
      # Name of output directory (the rdoc option --output); extracted from
      # gemspec; defaults to rdoc.
      #
      # @return [String]
      #
      attr_accessor :output

      #
      # Name of file to display in index.html (the rdoc option --main);
      # extracted from gemspec; defaults to nil (none).
      #
      # @return [String, nil]
      #
      attr_accessor :main

      #
      # Title for HTML output (the rdoc option --title); extracted from gemspec;
      # defaults to nil (unspecified).
      #
      # @return [String, nil]
      #
      attr_accessor :title

      #
      # Name of template used to generate html output (the rdoc option
      # --template); extracted from gemspec; defaults to nil (unspecified).
      #
      # @return [String, nil]
      #
      attr_accessor :template

      #
      # Files and directories to be processed by rdoc; extracted from gemspec;
      # by default, these are the gem's +require_paths+ and +extra_rdoc_files+.
      #
      # @return [Array<String>]
      #
      attr_accessor :files

      #
      # Options to be passed to rdoc; extracted from gemspec; note that
      # the {#output}, {#main}, {#title} and {#template} options and the
      # {#files} list are handled separately.
      #
      # @return [Array<String>]
      #
      attr_accessor :options

      #
      # Customize the rdoc task.
      #
      # @yield [rd] called after the defaults are set but before the rdoc tasks
      # are generated
      #
      # @yieldparam [Rake::RDocTask] rd
      #
      # @return [nil]
      #
      def with_rdoc_task(&block)
        @with_rdoc_task = block
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
        Rake::RDocTask.new(task_name) do |rd|
          rd.rdoc_dir      = output
          rd.rdoc_files    = files
          rd.title         = title
          rd.main          = main
          rd.template      = template
          rd.options       = options
          @with_rdoc_task&.call(rd)
        end
        CLOBBER.include(output)

        nil
      end
    end
  end
end
