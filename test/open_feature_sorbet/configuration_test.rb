# typed: true
# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < Minitest::Test
  def teardown
    OpenFeatureSorbet.configuration.reset!
  end

  def test_configuration_is_initialized_properly
    assert_equal("No Op Provider", OpenFeatureSorbet::Configuration.instance.provider_metadata.name)
    assert_empty(OpenFeatureSorbet::Configuration.instance.hooks)
    assert_nil(OpenFeatureSorbet::Configuration.instance.evaluation_context)
  end

  # rubocop:disable Metrics/AbcSize, Minitest/MultipleAssertions
  def test_configuration_can_be_reset
    OpenFeatureSorbet::Configuration.instance.provider = TestProvider.new
    OpenFeatureSorbet::Configuration.instance.hooks = [TestHook.new, TestHook.new]
    OpenFeatureSorbet::Configuration.instance.evaluation_context = OpenFeatureSorbet::EvaluationContext.new

    assert_equal("Test Provider", OpenFeatureSorbet::Configuration.instance.provider_metadata.name)
    assert_equal(2, OpenFeatureSorbet::Configuration.instance.hooks.size)
    refute_nil(OpenFeatureSorbet::Configuration.instance.evaluation_context)

    OpenFeatureSorbet::Configuration.instance.reset!

    assert_equal("No Op Provider", OpenFeatureSorbet::Configuration.instance.provider_metadata.name)
    assert_empty(OpenFeatureSorbet::Configuration.instance.hooks)
    assert_nil(OpenFeatureSorbet::Configuration.instance.evaluation_context)
  end
  # rubocop:enable Metrics/AbcSize, Minitest/MultipleAssertions
end
