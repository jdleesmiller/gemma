require "rubygems"
require "test/unit"
require "gemma"
require "rake"

class TestGemma < Test::Unit::TestCase
  def test_temp
    #TODO
  end

=begin
  def test_empty_spec
    s = Gem::Specification.new
    Gemma::Rakefile.new(s)
  end

  def test_rdoc
    s = Gem::Specification.new
    s.files = %w(lib/a.rb lib/b.rb)
    s.test_files = %w(test/test_a.rb test/test_a.rb)
    s.rdoc_options = ['--main', 'README.md']
    s.extra_rdoc_files = ['README.md', 'FAQ']

    Gemma::Rakefile.new(s) do |g|
      g.create_rdoc_tasks do |rd|
        assert_equal 4, rd.rdoc_files.size
        assert_equal [], rd.rdoc_files - %w(lib/a.rb lib/b.rb README.md FAQ)
        assert_equal %w(--main README.md), rd.options
      end
    end
  end

  def test_yardoc
    s = Gem::Specification.new
    s.files = %w(lib/a.rb)
    s.test_files = %w(test/test_a.rb)
    s.rdoc_options = ['--main', 'README.rdoc']
    s.extra_rdoc_files = ['README.rdoc']
 
    # Just one option.
    # A file should not be passed as an extra file if it's the --main file.
    # Test files should not be documented.
    Gemma::Rakefile.new(s) do |g|
      g.create_yard_tasks do |yd|
        assert_equal %w(--main README.rdoc), yd.options
        assert_equal %w(lib/a.rb), yd.files
      end
    end

    # Add some extra files (that aren't the --main file).
    s.extra_rdoc_files << 'FAQ'
    Gemma::Rakefile.new(s) do |g|
      g.create_yard_tasks do |yd|
        assert_equal %w(--main README.rdoc), yd.options
        assert_equal %w(lib/a.rb - FAQ), yd.files
      end
    end

    # Make sure extra options are ignored.
    s.rdoc_options = ['--main', 'README.rdoc', '--diagram']
    Gemma::Rakefile.new(s) do |g|
      g.create_yard_tasks do |yd|
        assert_equal %w(--main README.rdoc), yd.options
      end
    end
    s.rdoc_options = ['--diagram', '--main', 'README.rdoc']
    Gemma::Rakefile.new(s) do |g|
      g.create_yard_tasks do |yd|
        assert_equal %w(--main README.rdoc), yd.options
      end
    end

    # Some more complicated input.
    s.rdoc_options = ['foo bar', '--baz', 'bat', '--title', 'a b c',
      '--diagram', '--main', 'README.rdoc', 'ABCD']
    Gemma::Rakefile.new(s) do |g|
      g.create_yard_tasks do |yd|
        assert_equal ['--title', 'a b c', '--main', 'README.rdoc'], yd.options
      end
    end
  end
=end
end

