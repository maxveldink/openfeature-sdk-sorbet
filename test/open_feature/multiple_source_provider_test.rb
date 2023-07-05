# typed: true
# frozen_string_literal: true

require "test_helper"

class MultipleSourceProviderTest < Minitest::Test
  def setup
    @first_provider_returns = OpenFeature::MultipleSourceProvider.new(
      providers: [
        TestProvider.new,
        OpenFeature::NoOpProvider.new
      ]
    )
    @second_provider_returns = OpenFeature::MultipleSourceProvider.new(
      providers: [
        TestProvider.new(erroring: true),
        TestProvider.new
      ]
    )
    @no_providers_return = OpenFeature::MultipleSourceProvider.new(
      providers: [
        TestProvider.new(erroring: true),
        TestProvider.new(erroring: true)
      ]
    )
    @provider_raises = OpenFeature::MultipleSourceProvider.new(
      providers: [
        TestProvider.new(erroring: true),
        TestProvider.new(raising: true)
      ]
    )
  end

  def test_sets_status_to_ready
    assert_equal(OpenFeature::ProviderStatus::Ready, @first_provider_returns.status)
  end

  def test_metadata_combines_all_providers
    assert_equal("Multiple Sources: Test Provider, No Op Provider", @first_provider_returns.metadata.name)
  end

  def test_hooks_combine_all_providers
    assert_equal(1, @first_provider_returns.hooks.size)
  end

  def test_shutdown_can_be_called
    Counter.instance.intialize

    OpenFeature::MultipleSourceProvider.new(
      providers: [
        TestProvider.new(counter: Counter.instance),
        TestProvider.new(counter: Counter.instance)
      ]
    ).shutdown

    assert_equal(2, Counter.instance.shutdown_calls)

    Counter.instance.reset!
  end

  def test_boolean_value_returns_from_first_provider
    expected_details = OpenFeature::ResolutionDetails.new(value: true, reason: "STATIC")

    assert_equal(
      expected_details,
      @first_provider_returns.resolve_boolean_value(flag_key: "testing", default_value: true)
    )
  end

  def test_boolean_value_returns_from_second_provider
    expected_details = OpenFeature::ResolutionDetails.new(value: true, reason: "STATIC")

    assert_equal(
      expected_details,
      @second_provider_returns.resolve_boolean_value(flag_key: "testing", default_value: true)
    )
  end

  def test_boolean_value_returns_default_when_all_providers_error
    expected_details = OpenFeature::ResolutionDetails.new(
      value: false,
      error_code: OpenFeature::ErrorCode::General,
      reason: "ERROR"
    )

    assert_equal(
      expected_details,
      @no_providers_return.resolve_boolean_value(flag_key: "testing", default_value: false)
    )
  end

  def test_boolean_value_returns_default_when_a_provider_raises
    expected_details = OpenFeature::ResolutionDetails.new(
      value: false,
      error_code: OpenFeature::ErrorCode::General,
      reason: "ERROR"
    )

    assert_equal(
      expected_details,
      @provider_raises.resolve_boolean_value(flag_key: "testing", default_value: false)
    )
  end

  def test_string_value_returns_from_first_provider
    expected_details = OpenFeature::ResolutionDetails.new(value: "testing", reason: "STATIC")

    assert_equal(
      expected_details,
      @first_provider_returns.resolve_string_value(flag_key: "testing", default_value: "fallback")
    )
  end

  def test_string_value_returns_from_second_provider
    expected_details = OpenFeature::ResolutionDetails.new(value: "testing", reason: "STATIC")

    assert_equal(
      expected_details,
      @second_provider_returns.resolve_string_value(flag_key: "testing", default_value: "fallback")
    )
  end

  def test_string_value_returns_default_when_all_providers_error
    expected_details = OpenFeature::ResolutionDetails.new(
      value: "fallback",
      error_code: OpenFeature::ErrorCode::General,
      reason: "ERROR"
    )

    assert_equal(
      expected_details,
      @no_providers_return.resolve_string_value(flag_key: "testing", default_value: "fallback")
    )
  end

  def test_string_value_returns_when_a_provider_raises
    expected_details = OpenFeature::ResolutionDetails.new(
      value: "fallback",
      error_code: OpenFeature::ErrorCode::General,
      reason: "ERROR"
    )

    assert_equal(
      expected_details,
      @provider_raises.resolve_string_value(flag_key: "testing", default_value: "fallback")
    )
  end

  def test_number_value_returns_from_first_provider
    expected_details = OpenFeature::ResolutionDetails.new(value: 2.4, reason: "STATIC")

    assert_equal(
      expected_details,
      @first_provider_returns.resolve_number_value(flag_key: "testing", default_value: 3)
    )
  end

  def test_number_value_returns_from_second_provider
    expected_details = OpenFeature::ResolutionDetails.new(value: 2.4, reason: "STATIC")

    assert_equal(
      expected_details,
      @second_provider_returns.resolve_number_value(flag_key: "testing", default_value: 3)
    )
  end

  def test_number_value_returns_default_when_all_providers_error
    expected_details = OpenFeature::ResolutionDetails.new(
      value: 3,
      error_code: OpenFeature::ErrorCode::General,
      reason: "ERROR"
    )

    assert_equal(
      expected_details,
      @no_providers_return.resolve_number_value(flag_key: "testing", default_value: 3)
    )
  end

  def test_number_value_returns_when_a_provider_raises
    expected_details = OpenFeature::ResolutionDetails.new(
      value: 3,
      error_code: OpenFeature::ErrorCode::General,
      reason: "ERROR"
    )

    assert_equal(
      expected_details,
      @provider_raises.resolve_number_value(flag_key: "testing", default_value: 3)
    )
  end

  def test_structure_value_returns_from_first_provider
    expected_details = OpenFeature::ResolutionDetails.new(value: { "testing" => "123" }, reason: "STATIC")

    assert_equal(
      expected_details,
      @first_provider_returns.resolve_structure_value(flag_key: "testing", default_value: { "something" => "else" })
    )
  end

  def test_structure_value_returns_from_second_provider
    expected_details = OpenFeature::ResolutionDetails.new(value: { "testing" => "123" }, reason: "STATIC")

    assert_equal(
      expected_details,
      @second_provider_returns.resolve_structure_value(flag_key: "testing", default_value: { "something" => "else" })
    )
  end

  def test_structure_value_returns_default_when_all_providers_error
    expected_details = OpenFeature::ResolutionDetails.new(
      value: { "something" => "else" },
      error_code: OpenFeature::ErrorCode::General,
      reason: "ERROR"
    )

    assert_equal(
      expected_details,
      @no_providers_return.resolve_structure_value(flag_key: "testing", default_value: { "something" => "else" })
    )
  end

  def test_structure_value_returns_when_a_provider_raises
    expected_details = OpenFeature::ResolutionDetails.new(
      value: { "something" => "else" },
      error_code: OpenFeature::ErrorCode::General,
      reason: "ERROR"
    )

    assert_equal(
      expected_details,
      @provider_raises.resolve_structure_value(flag_key: "testing", default_value: { "something" => "else" })
    )
  end
end
