# frozen_string_literal: true

require 'gemma/test_helper'
require 'tmpdir'
require 'open4'

#
# Run the 'gemma new' command and then run some basic commands to make sure that
# things worked out.
#
class Gemma::GemmaNewTest < Minitest::Test
  #
  # Run a command in a bundler-free environment and capture both stdout and
  # stderror output.
  #
  # We don't want to let our (gemma) bundler environment interfere with the
  # bundler environment that we want to set up for the test gem, so we use
  # bundler's +with_clean_env+ (which doesn't quite work yet in bundler 1.0, so
  # we have to hack things a bit more than should be necessary)
  #
  # We also don't want to generate lots of confusing test output, so we capture
  # stdout and stderr using Open4. (On 1.9.2, we can use <tt>Open3.popen2e</tt>,
  # which is nicer, but Open3 on ruby 1.8.7 doesn't let us get exitstatus.)
  #
  def run_cmd(*args)
    Bundler.with_original_env do
      # We have to clear RUBYOPT, because Bundler::ORIGINAL_ENV in the test
      # runner's process still contains some bundler stuff from rake's process.
      # This suggests that we might have to stop using rake's built-in TestTask,
      # and instead use one that runs the tests in a Bundler.with_clean_env
      # block. However, it usually doesn't seem to make a difference, unless
      # you're doing strange things like we are here.
      ENV.delete('RUBYOPT')

      output = nil
      status = Open4.popen4(*args) do |_pid, i, o, e|
        i.close
        output = o.read + e.read
      end
      [status, output]
    end
  end

  def setup
    # work in a temporary directory
    @tmp = Dir.mktmpdir('gemma')
    @old_pwd = Dir.pwd
    Dir.chdir(@tmp)

    # create a test gem; note that here we DO want the gemma bundler
    # environment, because it puts our gemma executable on the bin path
    output = `gemma new --name="test_gem"`
    raise "gemma new failed:\n#{output}" unless $CHILD_STATUS.exitstatus

    # we should get some TODOs from the template in the output
    assert_match(/TODO write your name/, output)

    Dir.chdir('test_gem')

    # edit the test gem's Gemfile to point to this gemma
    raise 'no Gemfile in test gem' unless File.exist?('Gemfile')

    File.open('Gemfile', 'a') do |f|
      f.puts "gem 'gemma', :path => #{@old_pwd.dump}"
    end

    # bundler will complain if we don't fill in the TODOs
    gemspec_name = 'test_gem.gemspec'
    gemspec = File.read(gemspec_name)
    gemspec.gsub!(/TODO\s*/, '')
    gemspec.gsub!("'homepage'", "'http://example.com'")
    File.open(gemspec_name, 'w') { |f| f.puts gemspec }

    # run bundler on the test gem; it should find the same gems that we're using
    # in the gemma bundle
    status, output = run_cmd('bundle', 'install', '--local')
    raise "bundle failed:\n#{output}" unless status.exitstatus.zero?

    # bundler should produce a lock file
    raise 'no Gemfile.lock in test gem' unless File.exist?('Gemfile.lock')
  end

  def teardown
    Dir.chdir(@old_pwd)
    FileUtils.remove_entry_secure @tmp
  end

  def test_rake
    # list the rake tasks; this ensures that gemma loaded
    status, output = run_cmd('rake -T')
    assert_equal 0, status.exitstatus
    assert_match(/rake test/, output)
    assert_match(/rake rdoc/, output)
    assert_match(/rake yard/, output)

    # run the tests; they should fail initially
    status, output = run_cmd('rake')
    assert status.exitstatus.nonzero?
    assert_match(/TODO write tests/, output)

    # generate rdoc output
    status, _output = run_cmd('rake rdoc')
    assert_equal 0, status.exitstatus

    # generate yard output
    status, _output = run_cmd('rake yard')
    assert_equal 0, status.exitstatus

    # build the gem
    status, _output = run_cmd('rake build')
    assert_equal 0, status.exitstatus
  end
end
