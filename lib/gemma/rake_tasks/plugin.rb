module Gemma
  class RakeTasks
    # 
    # Plugins generate rake tasks based on the content of the gemspec.
    #
    # The intention is that the plugin processes the gemspec and sets
    # (intelligent) default values when it is created. The {RakeTasks} object
    # then calls {#create_rake_tasks} on every plugin that it knows about, after
    # it has run its configuration block. The configuration block gives the
    # caller a chance to customize the inputs to all of the plugins before they
    # are generated.
    #
    class Plugin
      include Rake::DSL

      def initialize gemspec
        @gemspec = gemspec
      end

      #
      # @return [Gem::Specification]
      #
      attr_reader :gemspec

      #
      # Internal method called by {RakeTasks} after the configuration block
      # has executed; overriden by plugins to create rake tasks.
      #
      # @return [nil]
      #
      # @abstract
      #
      def create_rake_tasks
        raise NotImplementedError
      end
    end
  end
end
