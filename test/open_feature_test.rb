# typed: true
# frozen_string_literal: true

class OpenFeatureTest < Minitest::Test
  def test_returns_provider_metadata
    assert_equal(OpenFeature::ProviderMetadata.new(name: "No Op Provider"), OpenFeature.provider_metadata)
  end
end
