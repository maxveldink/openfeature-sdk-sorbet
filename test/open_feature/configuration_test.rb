# typed: true
# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < Minitest::Test
  def teardown
    OpenFeature.configuration.reset!
  end

  def test_configuration_is_initialized_properly
    assert_equal("No Op Provider", OpenFeature::Configuration.instance.provider_metadata.name)
    assert_empty(OpenFeature::Configuration.instance.hooks)
    assert_nil(OpenFeature::Configuration.instance.evaluation_context)
  end

  # rubocop:disable Metrics/AbcSize, Minitest/MultipleAssertions
  def test_configuration_can_be_reset
    OpenFeature::Configuration.instance.provider = TestProvider.new
    OpenFeature::Configuration.instance.hooks = [TestHook.new, TestHook.new]
    OpenFeature::Configuration.instance.evaluation_context = OpenFeature::EvaluationContext.new

    assert_equal("Test Provider", OpenFeature::Configuration.instance.provider_metadata.name)
    assert_equal(2, OpenFeature::Configuration.instance.hooks.size)
    refute_nil(OpenFeature::Configuration.instance.evaluation_context)

    OpenFeature::Configuration.instance.reset!

    assert_equal("No Op Provider", OpenFeature::Configuration.instance.provider_metadata.name)
    assert_empty(OpenFeature::Configuration.instance.hooks)
    assert_nil(OpenFeature::Configuration.instance.evaluation_context)
  end
  # rubocop:enable Metrics/AbcSize, Minitest/MultipleAssertions
end
