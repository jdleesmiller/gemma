require 'rake/clean'

module Gemma
  #
  # Generate standard gem development tasks; the tasks are configured using
  # the settings in the given gemspec file.
  #
  # @example To create the default tasks based on your _mygem_.gemspec file:
  #   # At the top of Rakefile.rb.
  #   require 'rubygems'
  #   require 'bundler/setup'
  #   require 'gemma'
  #
  #   Gemma::RakeTasks.with_gemspec_file 'mygem.gemspec'
  #
  #   # ... other tasks ...
  #
  class RakeTasks

    # Alias for new.
    class <<self
      alias :with_gemspec_file :new
    end

    #
    # Constructor mainly for internal use; you should usually use the
    # `with_gemspec_file` alias (see examples in {RakeTasks}).
    #
    # @param [String, Gem::Specification] gemspec either the name of a gemspec
    # file or a gemspec object; the latter is intended mainly for testing
    #
    # @yield [tasks] used to customize the tasks to be created
    #
    # @yieldparam [Gemma::RakeTasks] tasks self
    #
    # @private
    #
    def initialize gemspec, &block
      # Load gemspec.
      if gemspec.is_a?(String)
        @gemspec_file_name = gemspec
        @gemspec = Gem::Specification::load(gemspec_file_name)
      elsif gemspec.is_a?(Gem::Specification)
        @gemspec_file_name = nil
        @gemspec = gemspec
      else
        raise ArgumentError, 'bad gemspec argument'
      end

      @plugins = {}
      create_default_plugins

      # Let the user add more plugins and alter settings.
      block.call(self) if block_given?

      @plugins.values.each do |plugin|
        begin
          plugin.create_rake_tasks
        rescue
          warn "plugin #{plugin.class} failed: #{$!}"
        end
      end
    end

    #
    # File from which the {#gemspec} was loaded.
    #
    # @return [String] not nil if a gemspec file name was passed to the
    # constructor; otherwise, nil
    #
    attr_reader :gemspec_file_name

    #
    # The specification used to configure the rake tasks.
    #
    # @return [Gem::Specification] not nil; you should not modify this object
    # (make the changes in the gemspec file instead).
    #
    attr_reader :gemspec

    #
    # @return [Hash<Symbol, Plugin>]
    #
    attr_reader :plugins

    #
    # @return [RDocTasks]
    #
    def rdoc; @plugins[:rdoc] end

    #
    # @return [MinitestTasks]
    #
    def test; @plugins[:test] end

    #
    # @return [YardTasks]
    #
    def yard; @plugins[:yard] end

    #
    # @return [GemTasks]
    #
    def gem; @plugins[:gem] end

    protected

    def create_default_plugins
      @plugins[:rdoc] = Gemma::RakeTasks::RDocTasks.new(gemspec)
      @plugins[:test] = Gemma::RakeTasks::MinitestTasks.new(gemspec)
      @plugins[:yard] = Gemma::RakeTasks::YardTasks.new(gemspec)
      @plugins[:gem] = Gemma::RakeTasks::GemTasks.new(gemspec,gemspec_file_name)
    end
  end
end
