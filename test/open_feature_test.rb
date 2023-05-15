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
    assert_equal("No Op Provider", OpenFeature.provider_metadata.name)

    OpenFeature.set_provider(TestProvider.new)

    assert_equal("Test Provider", OpenFeature.provider_metadata.name)
  end
end
