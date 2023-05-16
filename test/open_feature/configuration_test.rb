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

  def test_hooks_can_be_cleared
    OpenFeature::Configuration.instance.hooks = [OpenFeature::Hook.new, OpenFeature::Hook.new]

    OpenFeature::Configuration.instance.clear_hooks!

    assert_empty(OpenFeature::Configuration.instance.hooks)
  end
end
