require 'test_helper'

class ApiTokenTest < Test::Unit::TestCase
  def setup
    @token = ::ApiToken.create
  end

  def test_it_should_create_a_url_safe_string_as_a_token
    assert_equal String, @token.class
  end

  def test_a_token_with_the_corre_t_info_and_time_stamp_lt_10_mins_old_is_valid
    assert ApiToken.valid?(@token)
  end

  def test_a_nil_toke_is_invalid
    refute ApiToken.valid?(nil)
  end

  def test_a_non_base64_string_is_invalid
    refute ApiToken.valid?("random_attempt_at_url_token")
  end

  def test_an_base64_string_not_created_by_ApiToken_is_invalid
    invalid_base64_string = "b0D8U3jdeUXFs0vgQrVZbupnqb5d0UDo8cDd-iazDCs="
    refute ApiToken.valid?(invalid_base64_string)
  end

  def test_a_token_with_the_correct_info_and_time_stamp_gt_10_mins_old_is_invalid
    eleven_minutes_from_now = Time.now.utc.to_i + (60*11)
    ApiToken.stubs(:timestamp).returns(eleven_minutes_from_now)
    refute ApiToken.valid?(@token)
  end
end