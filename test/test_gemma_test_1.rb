require "test/unit"
require "rubygems"
require "gemma"
require "set"

#
# Tests on a gem skeleton that was generated with gemma.
#
# Some of these tests involve running rake on the test gem. The resulting
# coverage isn't counted by rcov, but we could fix with --save and --aggregate.
#
class TestGemmaTest1 < Test::Unit::TestCase
  def setup
    @lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
    @test_gem = File.join(File.dirname(__FILE__), 'gemma_test_1')
  end

  #
  # Make sure we can actually run a program with the task; so far I haven't
  # figured out any smart way to do this. Here the program creates just a
  # marker file that we can detect.
  #
  def test_run
    marker = 'gemma_test_1_marker.txt'
    Dir.chdir(@test_gem) do
      FileUtils.rm_f marker
      assert !File.exists?(marker)
      system "rake", '-I', @lib_path, '--quiet', 'gemma_test_1'
      assert  File.exists?(marker)
      FileUtils.rm_f marker
    end
  end

  #
  # Check that the bundler build call works; it is harder to check release and
  # install.
  #
  def test_bundler_exec
    Dir.chdir(@test_gem) do
      system "rake", '-I', @lib_path, 'clobber'
      assert !File.exists?(File.join('pkg', 'gemma_test_1-0.0.1.gem'))
      system "rake", '-I', @lib_path, 'build'
      assert  File.exists?(File.join('pkg', 'gemma_test_1-0.0.1.gem'))
    end
  end

  #
  # There are still a few TODOs left in the test project in README.rdoc.
  #
  def test_todos
    # Can't have binary files; they cause encoding errors.
    Dir.chdir(@test_gem) do
      system "rake", '-I', @lib_path, 'clobber'
    end

    io = StringIO.new
    Gemma::Utility.rgrep(/TODO/, @test_gem, io)
    assert io.string =~ /README\.rdoc/
  end
end

