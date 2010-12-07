require "test/unit"
require "gemma"
require "set"

class TestGemma < Test::Unit::TestCase
  # Can load empty spec.
  def test_empty_spec
    s = Gem::Specification.new
    Gemma::RakeTasks.new(s)
  end

  def test_rdoc_tasks
    s = Gem::Specification.new
    s.files = %w(lib/a.rb lib/b.rb)
    s.test_files = %w(test/test_a.rb test/test_a.rb)
    s.rdoc_options = ['--main', 'README.md']
    s.extra_rdoc_files = ['README.md', 'FAQ']

    Gemma::RakeTasks.new(s) do |g|
      assert_equal %w(lib FAQ README.md).to_set, g.rdoc.files.to_set
      assert_equal [], g.rdoc.options
      assert_equal 'README.md', g.rdoc.main
      assert_equal nil, g.rdoc.title

      g.rdoc.with_rdoc_task do |rd|
        assert_equal rd.rdoc_files, g.rdoc.files
      end
    end
  end

  def test_run_tasks
    s = Gem::Specification.new
    s.files = %w(lib/a.rb)
    s.executables = %w(a b)
    s.test_files = %w(test/test_a.rb)

    Gemma::RakeTasks.new(s) do |g|
      assert_equal %w(a b).to_set, g.run.program_names.to_set
    end
  end

  def test_yard_tasks
    s = Gem::Specification.new
    s.files = %w(lib/a.rb)
    s.test_files = %w(test/test_a.rb)
    s.rdoc_options = ['--main', 'README.rdoc']
    s.extra_rdoc_files = ['README.rdoc']
 
    # Just one option.
    # A file should not be passed as an extra file if it's the --main file.
    # Test files should not be documented.
    Gemma::RakeTasks.new(s) do |g|
      assert_equal %w(lib), g.yard.files
      assert_equal [], g.yard.extra_files
      assert_equal 'README.rdoc', g.yard.main
      assert_equal [], g.yard.options
      assert_equal 'yard', g.yard.output
      assert_equal :yard, g.yard.task_name
      assert_equal nil, g.yard.title

      g.yard.with_yardoc_task do |yd|
        assert_equal %w(lib), yd.files
        assert_equal 4, yd.options.size
        assert_equal 'README.rdoc',
          Gemma::Options.extract(%w(--main), yd.options).argument
        assert_equal 'yard',
          Gemma::Options.extract(%w(--output), yd.options).argument
      end
    end

    # Add some extra files (that aren't the --main file).
    s.extra_rdoc_files << 'FAQ'
    Gemma::RakeTasks.new(s) do |g|
      assert_equal %w(lib), g.yard.files
      assert_equal %w(FAQ), g.yard.extra_files
      assert_equal 'README.rdoc', g.yard.main
      assert_equal [], g.yard.options
    end

    # Make sure extra options are ignored.
    s.rdoc_options = ['--main', 'README.rdoc', '--diagram']
    Gemma::RakeTasks.new(s) do |g|
      assert_equal %w(lib), g.yard.files
      assert_equal %w(FAQ), g.yard.extra_files
      assert_equal 'README.rdoc', g.yard.main
      assert_equal [], g.yard.options
    end
    s.rdoc_options = ['--diagram', '--main', 'README.rdoc']
    Gemma::RakeTasks.new(s) do |g|
      assert_equal %w(lib), g.yard.files
      assert_equal %w(FAQ), g.yard.extra_files
      assert_equal 'README.rdoc', g.yard.main
      assert_equal [], g.yard.options
    end

    # Some more complicated options.
    # Note that we ignore things that could be files ('bat').
    s.rdoc_options = ['foo bar', '--baz', 'bat', '--title', 'a b c',
      '--diagram', '--main', 'README.rdoc', 'ABCD']
    Gemma::RakeTasks.new(s) do |g|
      assert_equal 'a b c', g.yard.title
      assert_equal [], g.yard.options

      g.yard.with_yardoc_task do |yd|
        assert_equal %w(lib - FAQ), yd.files
        assert_equal 6, yd.options.size
        assert_equal 'README.rdoc',
          Gemma::Options.extract(%w(--main), yd.options).argument
        assert_equal 'yard',
          Gemma::Options.extract(%w(--output), yd.options).argument
        assert_equal 'a b c',
          Gemma::Options.extract(%w(--title), yd.options).argument
      end
    end
  end

  def test_test_unit_tasks
    s = Gem::Specification.new
    s.files = %w(lib/a.rb lib/b.rb)
    s.test_files = %w(test/test_a.rb test/test_b.rb)
    s.require_paths << 'ext'

    Gemma::RakeTasks.new(s) do |g|
      g.test.with_test_task do |tt|
        assert_equal %w(lib ext).to_set, tt.libs.to_set
        assert_equal %w(test/test_a.rb test/test_b.rb).to_set,
          tt.file_list.to_a.to_set
      end
    end
  end

  def test_rcov_tasks
    s = Gem::Specification.new
    s.files = %w(lib/a.rb lib/b.rb)
    s.test_files = %w(test/test_a.rb test/test_b.rb)
    s.require_paths << 'ext'

    Gemma::RakeTasks.new(s) do |g|
      g.rcov.with_rcov_task do |rcov|
        assert_equal %w(lib ext).to_set, rcov.libs.to_set
        assert_equal %w(test/test_a.rb test/test_b.rb).to_set,
          rcov.file_list.to_a.to_set
      end
    end
  end

  def test_conventions_good_gem_name
    assert  Gemma::Conventions.good_gem_name?("my_gem_name")
    assert  Gemma::Conventions.good_gem_name?("my-gem-name")
    assert  Gemma::Conventions.good_gem_name?("foo")
    assert  Gemma::Conventions.good_gem_name?("foo1")
    assert  Gemma::Conventions.good_gem_name?("foo_4_bar")
    assert !Gemma::Conventions.good_gem_name?("Foo")
    assert !Gemma::Conventions.good_gem_name?("FooBar")
    assert !Gemma::Conventions.good_gem_name?("Foo_Bar")
    assert !Gemma::Conventions.good_gem_name?("Foo-Bar")
  end

  def test_conventions_gem_name_to_module_name
    assert_equal 'MyGem',
      Gemma::Conventions.gem_name_to_module_name("my_gem")
    assert_equal 'MyGem3',
      Gemma::Conventions.gem_name_to_module_name("my_gem3")
    assert_equal 'A4B',
      Gemma::Conventions.gem_name_to_module_name("a_4_b")
    assert_equal 'A4b',
      Gemma::Conventions.gem_name_to_module_name("a4b")
  end

  #
  # Exercise usage message for bin/gemma.
  #
  def test_print_usage
    gemma_file = File.join(File.dirname(__FILE__), '..', 'bin', 'gemma')
    io = StringIO.new
    Gemma::Utility.print_usage_from_file_comment gemma_file, '#', io
    assert io.string =~ /gemma/
  end

  def test_plugin_abstract
    s = Gem::Specification.new
    plugin = Gemma::RakeTasks::Plugin.new(s)
    assert_raise(NotImplementedError) {
      plugin.create_rake_tasks # abstract method
    }
  end
end

