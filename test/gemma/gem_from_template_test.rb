# frozen_string_literal: true
require 'gemma/test_helper'
require 'tmpdir'

class Gemma::GemFromTemplateTest < MiniTest::Test
  def setup
    @tmp = Dir.mktmpdir('gemma')
    @old_pwd = Dir.pwd
    Dir.chdir(@tmp)
  end

  def teardown
    Dir.chdir(@old_pwd)
    FileUtils.remove_entry_secure @tmp
  end

  def test_create
    #
    # basic create-from-template tests
    #
    gt = Gemma::GemFromTemplate.new
    gt.gem_name = 'my_new_gem'
    assert gt.good_gem_name?

    assert_equal 'MyNewGem', gt.module_name
    gt.module_name = 'Foo' # override default
    assert_equal 'Foo', gt.module_name
    gt.module_name = nil # revert back to default
    assert_equal 'MyNewGem', gt.module_name

    assert_equal 'my_new_gem', gt.dir_name
    gt.dir_name = 'bar' # override default
    assert_equal 'bar', gt.dir_name
    gt.dir_name = nil # revert back to default
    assert_equal 'my_new_gem', gt.dir_name

    template_paths = Gemma::GemFromTemplate::BUILTIN_TEMPLATES.map{|path|
      File.join(Gemma::GemFromTemplate::TEMPLATE_ROOT, path)}
    assert_equal 'base', File.basename(template_paths.first)

    gt.dir_name = 'my_new_gem_base'
    gt.create_gem template_paths[0..0] # just base

    gt.dir_name = 'my_new_gem_full'
    gt.create_gem template_paths # expand all templates
  end

  def test_todos
    #
    # we should be able to find the to-do markers in a newly created gem
    #
    gt = Gemma::GemFromTemplate.new
    gt.gem_name = 'test_gem'

    template_paths = Gemma::GemFromTemplate::BUILTIN_TEMPLATES.map{|path|
      File.join(Gemma::GemFromTemplate::TEMPLATE_ROOT, path)}
    gt.create_gem template_paths

    # look for some to-do markers
    io = StringIO.new
    Gemma::Utility.rgrep(/TODO/, gt.destination_path, io)
    assert io.string =~ /README\.rdoc/
  end
end
