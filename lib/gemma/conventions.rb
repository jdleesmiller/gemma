module Gemma
  #
  # A home for conventions, advice and best practices.
  #
  module Conventions
    #
    # References:
    # http://stackoverflow.com/questions/221320/standard-file-naming-conventions-in-ruby
    # http://containerdiv.wordpress.com/2009/05/24/ruby-gems-vs-rails-plugins/
    #
    # There is probably a required format (regex) for names, but I've never
    # figured out what it is. It should be a valid file/directory name on
    # Windows.
    #
    GOOD_GEM_NAME_TIPS = <<-STRING
    Some tips for good gem names:
      * use lower case
      * separate words with _ (underscore)
      * don't put 'ruby' in the name; this is implied, because it's a rubygem

    It is also common to use a hyphen (-) to separate words.

    If your gem name is my_new_gem, it can be installed with
      sudo gem install my_new_gem
    used in scripts with
      require 'rubygems'
      require 'my_new_gem'
    and its contents should be contained in a module or class called MyNewGem.
    STRING

    #
    # Check gem naming conventions; this is sufficient but not necessary for
    # the gem name to be valid.
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

