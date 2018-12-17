require 'test_helper'

class SecureApiTest < Minitest::Test
  def test_configuration_accessor
    config = SecureApi.configuration
    assert config
    assert_kind_of SecureApi::Configuration, config
  end
end
