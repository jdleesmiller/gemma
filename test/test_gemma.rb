require "test/unit"
require "rubygems"
require "gemma"
require "set"

class TestGemma < Test::Unit::TestCase
  def test_empty_spec
    s = Gem::Specification.new
    Gemma::RakeTasks.new(s)
  end

  def test_rdoc
    s = Gem::Specification.new
    s.files = %w(lib/a.rb lib/b.rb)
    s.test_files = %w(test/test_a.rb test/test_a.rb)
    s.rdoc_options = ['--main', 'README.md']
    s.extra_rdoc_files = ['README.md', 'FAQ']

    Gemma::RakeTasks.new(s) do |g|
      assert_equal %w(lib/a.rb lib/b.rb README.md FAQ).to_set,
        g.rdoc.files.to_set
      assert_equal [], g.rdoc.options
      assert_equal 'README.md', g.rdoc.main
      assert_equal nil, g.rdoc.title

      g.rdoc.with_rdoc_task do |rd|
        assert_equal rd.rdoc_files, g.rdoc.files
      end
    end
  end

  def test_yard
    s = Gem::Specification.new
    s.files = %w(lib/a.rb)
    s.test_files = %w(test/test_a.rb)
    s.rdoc_options = ['--main', 'README.rdoc']
    s.extra_rdoc_files = ['README.rdoc']
 
    # Just one option.
    # A file should not be passed as an extra file if it's the --main file.
    # Test files should not be documented.
    Gemma::RakeTasks.new(s) do |g|
      assert_equal %w(lib/a.rb), g.yard.files
      assert_equal [], g.yard.extra_files
      assert_equal 'README.rdoc', g.yard.main
      assert_equal [], g.yard.options
      assert_equal 'yard', g.yard.output
      assert_equal :yard, g.yard.task_name
      assert_equal nil, g.yard.title

      g.yard.with_yardoc_task do |yd|
        assert_equal %w(lib/a.rb), yd.files
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
      assert_equal %w(lib/a.rb), g.yard.files
      assert_equal %w(FAQ), g.yard.extra_files
      assert_equal 'README.rdoc', g.yard.main
      assert_equal [], g.yard.options
    end

    # Make sure extra options are ignored.
    s.rdoc_options = ['--main', 'README.rdoc', '--diagram']
    Gemma::RakeTasks.new(s) do |g|
      assert_equal %w(lib/a.rb), g.yard.files
      assert_equal %w(FAQ), g.yard.extra_files
      assert_equal 'README.rdoc', g.yard.main
      assert_equal [], g.yard.options
    end
    s.rdoc_options = ['--diagram', '--main', 'README.rdoc']
    Gemma::RakeTasks.new(s) do |g|
      assert_equal %w(lib/a.rb), g.yard.files
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
        assert_equal %w(lib/a.rb - FAQ), yd.files
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

  def test_test_unit
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

  def test_rcov
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
end

