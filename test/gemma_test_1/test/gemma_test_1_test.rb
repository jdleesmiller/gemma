puts $:
require "test/gemma_test_1_test_helper"

class TestGemmaTest1 < Test::Unit::TestCase
  def test_gemma_test_1
    # helper_add is defined in test/gemma_test_1_test_helper
    assert_equal 2, helper_add(1, 1)
  end
end

