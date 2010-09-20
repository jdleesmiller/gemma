require "test/unit"
require "rubygems"
require "gemma"

class TestOptions < Test::Unit::TestCase
  include Gemma

  def test_empty 
    # empty input
    assert_equal Options::ExtractResult.new(nil, []),
      Options.extract(%w(--a), [])
  end

  def test_long_form
    input = %w(--a av --b --c=cv)

    # option a has an argument
    assert_equal Options::ExtractResult.new('av', %w(--b --c=cv)),
      Options.extract(%w(--a), input)

    # option b has no argument; result is ''
    assert_equal Options::ExtractResult.new('', %w(--a av --c=cv)),
      Options.extract(%w(--b), input)

    # option c also has argument
    assert_equal Options::ExtractResult.new('cv', %w(--a av --b)),
      Options.extract(%w(--c), input)

    # there is no option d; result is nil
    assert_equal Options::ExtractResult.new(nil, input),
      Options.extract(%w(--d), input)
  end

  def test_terminator
    # just the -- terminator
    assert_equal Options::ExtractResult.new(nil, ['--']),
      Options.extract(%w(--a), ['--'])

    # should keep content before and after the -- terminator
    assert_equal Options::ExtractResult.new(nil, %w(a -- b)),
      Options.extract(%w(--a), %w(a -- b))
  end

  def test_terminator_2
    input = %w(foo --a av  -- --b bv)

    # should not be able to find options after the -- terminator 
    assert_equal Options::ExtractResult.new('av', %w(foo -- --b bv)),
      Options.extract(%w(--a), input)
    assert_equal Options::ExtractResult.new(nil, input),
      Options.extract(%w(--b), input)
    assert_equal Options::ExtractResult.new('', %w(-- --b)),
      Options.extract(%w(--a), %w(--a -- --b))
    assert_equal Options::ExtractResult.new(nil, %w(--a -- --b)),
      Options.extract(%w(--b), %w(--a -- --b))
  end

  def test_short_form
    # should be able to find -a but not -b
    input = %w(foo -a av  -- -b bv)
    assert_equal Options::ExtractResult.new('av', %w(foo -- -b bv)),
      Options.extract(%w(-a), input)
    assert_equal Options::ExtractResult.new(nil, input),
      Options.extract(%w(-b), input)

    # the -aav and -b bv forms
    input = %w(-aav -b bv)
    assert_equal Options::ExtractResult.new('av', %w(-b bv)),
      Options.extract(%w(-a), input)
    assert_equal Options::ExtractResult.new('bv', %w(-aav)),
      Options.extract(%w(-b), input)

    # short form with no argument
    assert_equal Options::ExtractResult.new('', %w(-a av)),
      Options.extract(%w(-b), %w(-a av -b))

    # missing short form argument
    assert_equal Options::ExtractResult.new(nil, %w(-a av -b foo bar.txt)),
      Options.extract(%w(-c), %w(-a av -b foo bar.txt))
  end

  def test_multiple_options
    # single -a means we pick up a1
    assert_equal Options::ExtractResult.new('a1', []),
      Options.extract(%w(-a), %w(-a a1))

    # the second -a means that we pick up a2
    assert_equal Options::ExtractResult.new('a2', []),
      Options.extract(%w(-a), %w(-a a1 -a a2))
    assert_equal Options::ExtractResult.new('a2', %w(hi -bfoo)),
      Options.extract(%w(-a), %w(hi -a a1 -a a2 -bfoo))

    # mixing long and short forms doesn't affect this
    assert_equal Options::ExtractResult.new('a2', []),
      Options.extract(%w(-a --a), %w(-a a1 --a a2))

    # a duplicate option after the -- terminator makes no difference
    assert_equal Options::ExtractResult.new('a1', %w(-- -aa2)),
      Options.extract(%w(-a), %w(-a a1 -- -aa2))
  end
end
