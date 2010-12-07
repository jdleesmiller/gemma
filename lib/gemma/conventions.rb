module Gemma
  #
  # A home for conventions, advice and best practices.
  #
  # Some other notes, to be integrated somewhere, someday:
  # * Do not do require 'rubygems' in lib or bin files; rubygems sets up the
  #   load paths automatically in a wrapper for your gem executables.
  # * For test files submitted with the gem (as +test_files+ in the gemspec),
  #   running
  #     gem check my_gem --test
  #   also loads rubygems automatically. As of 1.0.1, the test_unit task passes
  #   -rubygems to the test runner, so you don't have to explicitly require
  #   'rubygems' in the test files either.
  # * One often wants a 'test helper' file to be included in all of the test
  #   files. The gem check --test command puts the gem's root directory on the
  #   require path, and the gem's development root is on the load path when you
  #   run rake test. So, the easiest way seems to be to create a file
  #   test/my_gem_test_helper.rb and
  #     require 'test/my_gem_test_helper.rb'
  #   from all of your test_feature.rb files. You also have to add
  #   test/my_gem_test_helper.rb to the gemspec's +files+ list (but not its
  #   +test_files+ list), in order to make gem check --test work.
  # * An alternative solution for the above is to just put your test helper code
  #   in a test/test_helper.rb file and make sure it's the first file in the
  #   +test_files+ list. The files are required (rubygems) or loaded (rake task)
  #   in the order in which they appear in test_files, so this works. However,
  #   it may be fragile; maintaining the order of the +test_files+ isn't
  #   documented behavior, AFAIK. It also breaks the TEST=... feature of the
  #   rake testtask (this feature allows you select only one test to run). (On
  #   the other hand, the fact that the gem root is on the load path isn't
  #   documented either.)
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

