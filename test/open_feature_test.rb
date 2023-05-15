# typed: true
# frozen_string_literal: true

require_relative "support/configuration_helper"
require_relative "support/test_provider"

class OpenFeatureTest < Minitest::Test
  def teardown
    ConfigurationHelper.reset!
  end

  def test_returns_provider_metadata
    assert_equal(OpenFeature::ProviderMetadata.new(name: "No Op Provider"), OpenFeature.provider_metadata)
  end

  def test_provider_can_be_set
    OpenFeature.set_provider(TestProvider.new)

    assert_equal("Test Provider", OpenFeature.provider_metadata.name)
  end

  def test_hooks_can_be_added
    OpenFeature.add_hooks(OpenFeature::Hook.new)
    OpenFeature.add_hooks([OpenFeature::Hook.new, OpenFeature::Hook.new])

    assert_equal(3, OpenFeature::Configuration.instance.hooks.size)
  end
end
