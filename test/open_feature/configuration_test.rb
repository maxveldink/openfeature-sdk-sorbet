# typed: true
# frozen_string_literal: true

require_relative "../support/configuration_helper"
require_relative "../support/test_provider"

class ConfigurationTest < Minitest::Test
  def teardown
    ConfigurationHelper.reset!
  end

  def test_provider_is_initialized_to_no_op
    assert_equal("No Op Provider", OpenFeature::Configuration.instance.provider_metadata.name)
  end

  def test_provider_can_be_set
    assert_equal("No Op Provider", OpenFeature::Configuration.instance.provider_metadata.name)

    OpenFeature.set_provider(TestProvider.new)

    assert_equal("Test Provider", OpenFeature::Configuration.instance.provider_metadata.name)
  end
end
