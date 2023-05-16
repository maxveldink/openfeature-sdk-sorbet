# typed: true
# frozen_string_literal: true

require "test_helper"
require_relative "../support/configuration_helper"
require_relative "../support/test_provider"

class ConfigurationTest < Minitest::Test
  def teardown
    ConfigurationHelper.reset!
  end

  def test_configuration_is_initialized_properly
    assert_equal("No Op Provider", OpenFeature::Configuration.instance.provider_metadata.name)
    assert_empty(OpenFeature::Configuration.instance.hooks)
    assert_nil(OpenFeature::Configuration.instance.evaluation_context)
  end

  def test_provider_can_be_set
    OpenFeature::Configuration.instance.set_provider(TestProvider.new)

    assert_equal("Test Provider", OpenFeature::Configuration.instance.provider_metadata.name)
  end

  def test_evaluation_context_can_be_set
    OpenFeature.set_evaluation_context(OpenFeature::EvaluationContext.new)

    refute_nil(OpenFeature::Configuration.instance.evaluation_context)
  end

  def test_hooks_can_be_added
    OpenFeature::Configuration.instance.add_hooks(OpenFeature::Hook.new)
    OpenFeature::Configuration.instance.add_hooks([OpenFeature::Hook.new, OpenFeature::Hook.new])

    assert_equal(3, OpenFeature::Configuration.instance.hooks.size)
  end

  def test_hooks_can_be_cleared
    OpenFeature::Configuration.instance.add_hooks([OpenFeature::Hook.new, OpenFeature::Hook.new])

    OpenFeature::Configuration.instance.clear_hooks!

    assert_empty(OpenFeature::Configuration.instance.hooks)
  end
end
