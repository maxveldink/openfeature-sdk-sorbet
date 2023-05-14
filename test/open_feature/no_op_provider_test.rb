# typed: true
# frozen_string_literal: true

require "test_helper"

class NoOpProviderTest < Minitest::Test
  def setup
    @provider = OpenFeature::NoOpProvider.new
  end

  def test_returns_name_in_metadata
    assert_equal("No Op Provider", @provider.metadata.name)
  end
end
