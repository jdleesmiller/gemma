require "test/unit"
require "gemma"

#
# Some tests that don't package well, because they have to create / delete files
# or do other things that aren't so easy once a gem is installed. In other
# words, the tests in test/test_gemma.rb will work if you run
#   gem check gemma --test
# on the installed gem, whereas these would fail.
#
# Some of these tests involve running rake on a test gem. The resulting
# coverage isn't counted by rcov, but we could fix with --save and --aggregate.
#
class TestGemmaDev < Test::Unit::TestCase
  def setup
    @lib_path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
    @test_gem = File.join(File.dirname(__FILE__), 'gemma_test_1')
  end

  # Can load our own spec (but the spec isn't packaged).
  def test_spec_from_file
    Dir.chdir(File.join(File.dirname(__FILE__), '..')) do
      Gemma::RakeTasks.new('gemma.gemspec') do |g|
        assert_equal 'gemma', g.gemspec.name
      end
    end
  end

  # Create some templates.
  def test_template
    gt = Gemma::GemFromTemplate.new
    gt.gem_name = "my_new_gem"
    assert gt.good_gem_name?
    
    assert_equal "MyNewGem", gt.module_name
    gt.module_name = "Foo" # override default
    assert_equal "Foo", gt.module_name
    gt.module_name = nil
    assert_equal "MyNewGem", gt.module_name

    assert_equal "my_new_gem", gt.dir_name
    gt.dir_name = "bar" # override default
    assert_equal "bar", gt.dir_name
    gt.dir_name = nil
    assert_equal "my_new_gem", gt.dir_name

    template_paths = Gemma::GemFromTemplate::BUILTIN_TEMPLATES.map{|path|
      File.join(Gemma::GemFromTemplate::TEMPLATE_ROOT,path)}
    assert File.basename(template_paths.first) == 'base'

    gt.dir_name = File.join('test', "my_new_gem_base")
    FileUtils.rm_r gt.destination_path if File.directory?(gt.destination_path)
    gt.create_gem template_paths[0..0]

    gt.dir_name = File.join('test', "my_new_gem_full")
    FileUtils.rm_r gt.destination_path if File.directory?(gt.destination_path)
    gt.create_gem template_paths
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
  # There are still a few TODOs left in the test project in README.rdoc.
  #
  def test_todos
    # Can't have any binary files; they cause encoding errors.
    Dir.chdir(@test_gem) do
      system "rake", '-I', @lib_path, 'clobber'
    end

    io = StringIO.new
    Gemma::Utility.rgrep(/TODO/, @test_gem, io)
    assert io.string =~ /README\.rdoc/
  end

  #
  # Run rake_test; it should succeed.
  #
  def test_rake_test
    Dir.chdir(@test_gem) do
      system "rake", '-I', @lib_path, 'test'
    end
    assert_equal 0, $?.exitstatus, "rake test failed"
  end
end

