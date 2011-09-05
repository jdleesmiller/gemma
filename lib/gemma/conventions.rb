module Gemma
  #
  # Methods to check input against accepted conventions.
  #
  # For help on extensions:
  # * http://nokogiri.org/tutorials/installing_nokogiri.html explains how to
  # prepare several unices to build native extensions. 
  #
  # General objectives for gemma:
  # * follow and promote accepted conventions where obvious
  # * make the outputs from rdoc, test, etc. work like they do in rubygems
  # * avoid load path noise ($: << ...)
  # * make it easy to start hacking on an existing gem that uses gemma
  #   - git clone ...
  #   - gem install bundle
  #   - bundle # install both gemma dependencies and the gem's dependencies
  #   - rake -T # should now work
  #
  module Conventions
    #
    # Check gem naming conventions; this is sufficient but not necessary for
    # the gem name to be valid.
    #
    # References:
    # * http://guides.rubygems.org/patterns/
    # * http://blog.segment7.net/articles/2010/11/15/how-to-name-gems
    # * http://stackoverflow.com/questions/221320/standard-file-naming-conventions-in-ruby
    # * http://containerdiv.wordpress.com/2009/05/24/ruby-gems-vs-rails-plugins/
    #
    # @return [Boolean]
    #
    def self.good_gem_name? gem_name
      gem_name =~ /^[a-z0-9]+[a-z0-9_\-]*$/
    end

    #
    # Convert from underscore-lower-case form to camel-case form; hyphens are
    # also converted to camel case.
    #
    # @return [String]
    #
    def self.gem_name_to_module_name gem_name
      gem_name.gsub(/(?:^|_|-)([a-z0-9])/) { $1.upcase }
    end
  end
end

