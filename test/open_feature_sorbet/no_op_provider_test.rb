# typed: true
# frozen_string_literal: true

require "test_helper"

class NoOpProviderTest < Minitest::Test
  def setup
    @provider = OpenFeatureSorbet::NoOpProvider.new
  end

  def test_sets_status_to_ready
    assert_equal(OpenFeatureSorbet::ProviderStatus::Ready, @provider.status)
  end

  def test_returns_name_in_metadata
    assert_equal("No Op Provider", @provider.metadata.name)
  end

  def test_hooks_is_empty
    assert_empty(@provider.hooks)
  end

  def test_resolve_boolean_value_returns_given_default
    assert_equal(
      OpenFeatureSorbet::ResolutionDetails.new(value: true, reason: "DEFAULT"),
      @provider.resolve_boolean_value(flag_key: "testing", default_value: true)
    )
  end

  def test_resolve_string_value_returns_given_default
    assert_equal(
      OpenFeatureSorbet::ResolutionDetails.new(value: "A Test Value", reason: "DEFAULT"),
      @provider.resolve_string_value(flag_key: "testing", default_value: "A Test Value")
    )
  end

  def test_resolve_number_value_returns_given_default
    assert_equal(
      OpenFeatureSorbet::ResolutionDetails.new(value: 4.3, reason: "DEFAULT"),
      @provider.resolve_number_value(flag_key: "testing", default_value: 4.3)
    )
  end

  def test_resolve_structure_value_returns_given_default
    assert_equal(
      OpenFeatureSorbet::ResolutionDetails.new(value: { "testing" => "123" }, reason: "DEFAULT"),
      @provider.resolve_structure_value(flag_key: "testing", default_value: { "testing" => "123" })
    )
  end
end
