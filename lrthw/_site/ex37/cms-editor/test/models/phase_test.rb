require 'test_helper'

class PhaseTest < ActiveSupport::TestCase
  def test_valid
    assert phases(:maximum_lengths_valid_phase).valid?, 'Maximum lengths should have been valid - has someone reduced a length?'
  end

  def test_start_after_end_invalid
    refute phases(:start_after_end_phase).valid?, 'End date should be required to be after start date'
  end

  def test_missing_title_invalid
    refute phases(:missing_title_phase).valid?, 'Title should be required'
  end

  def test_missing_summary_invalid
    refute phases(:missing_summary_phase).valid?, 'Summary should be required'
  end
end
