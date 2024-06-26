# typed: true
# frozen_string_literal: true

require "test_helper"

class ClientTest < Minitest::Test
  def setup
    @client_provider = TestProvider.new
    @client = OpenFeatureSorbet::Client.new(provider: @client_provider, name: "testing")
    @raising_client = OpenFeatureSorbet::Client.new(provider: TestProvider.new(raising: true))
    @integer_client = OpenFeatureSorbet::Client.new(provider: TestProvider.new(number_value: 2))
  end

  def test_is_initialized_properly_with_defaults
    client = OpenFeatureSorbet::Client.new(provider: TestProvider.new)

    assert_nil(client.client_metadata.name)
    assert_nil(client.evaluation_context)
    assert_empty(client.hooks)
  end

  def test_values_can_be_provided_during_initialization
    client = OpenFeatureSorbet::Client.new(
      provider: TestProvider.new,
      name: "testing",
      evaluation_context: OpenFeatureSorbet::EvaluationContext.new,
      hooks: [TestHook.new]
    )

    refute_nil(client.client_metadata.name)
    refute_nil(client.evaluation_context)
    refute_empty(client.hooks)
  end

  def test_hooks_can_be_added
    @client.add_hooks(TestHook.new)
    @client.add_hooks([TestHook.new, TestHook.new])

    assert_equal(3, @client.hooks.size)
  end

  def test_fetch_boolean_value_returns_provider_value
    result = @client.fetch_boolean_value(flag_key: "testing", default_value: false)

    assert(result)
  end

  def test_fetch_boolean_value_returns_default_if_provider_raises
    result = @raising_client.fetch_boolean_value(flag_key: "testing", default_value: false)

    refute(result)
  end

  def test_fetch_boolean_details_returns_details
    expected_details = OpenFeatureSorbet::EvaluationDetails.new(
      flag_key: "testing",
      value: true,
      reason: "STATIC"
    )

    details = @client.fetch_boolean_details(flag_key: "testing", default_value: false)

    assert_equal(expected_details, details)
  end

  def test_fetch_boolean_details_returns_details_when_provider_raises
    expected_details = OpenFeatureSorbet::EvaluationDetails.new(
      flag_key: "testing",
      value: false,
      reason: "ERROR",
      error_code: OpenFeatureSorbet::ErrorCode::General,
      error_message: "Provider raised error: TypeError"
    )

    details = @raising_client.fetch_boolean_details(flag_key: "testing", default_value: false)

    assert_equal(expected_details, details)
  end

  def test_fetch_string_value_returns_provider_value
    result = @client.fetch_string_value(flag_key: "testing", default_value: "fallback")

    assert_equal("testing", result)
  end

  def test_fetch_string_value_returns_default_if_provider_raises
    result = @raising_client.fetch_string_value(flag_key: "testing", default_value: "fallback")

    assert_equal("fallback", result)
  end

  def test_fetch_string_details_returns_details
    expected_details = OpenFeatureSorbet::EvaluationDetails.new(
      flag_key: "testing",
      value: "testing",
      reason: "STATIC"
    )

    details = @client.fetch_string_details(flag_key: "testing", default_value: "fallback")

    assert_equal(expected_details, details)
  end

  def test_fetch_string_details_returns_details_when_provider_raises
    expected_details = OpenFeatureSorbet::EvaluationDetails.new(
      flag_key: "testing",
      value: "fallback",
      reason: "ERROR",
      error_code: OpenFeatureSorbet::ErrorCode::General,
      error_message: "Provider raised error: TypeError"
    )

    details = @raising_client.fetch_string_details(flag_key: "testing", default_value: "fallback")

    assert_equal(expected_details, details)
  end

  def test_fetch_number_value_returns_provider_value
    result = @client.fetch_number_value(flag_key: "testing", default_value: 3.2)

    assert_in_delta(2.4, result)
  end

  def test_fetch_number_value_returns_default_if_provider_raises
    result = @raising_client.fetch_number_value(flag_key: "testing", default_value: 3.2)

    assert_in_delta(3.2, result)
  end

  def test_fetch_number_details_returns_details
    expected_details = OpenFeatureSorbet::EvaluationDetails.new(
      flag_key: "testing",
      value: 2.4,
      reason: "STATIC"
    )

    details = @client.fetch_number_details(flag_key: "testing", default_value: 3.2)

    assert_equal(expected_details, details)
  end

  def test_fetch_number_details_returns_details_when_provider_raises
    expected_details = OpenFeatureSorbet::EvaluationDetails.new(
      flag_key: "testing",
      value: 3.2,
      reason: "ERROR",
      error_code: OpenFeatureSorbet::ErrorCode::General,
      error_message: "Provider raised error: TypeError"
    )

    details = @raising_client.fetch_number_details(flag_key: "testing", default_value: 3.2)

    assert_equal(expected_details, details)
  end

  def test_fetch_integer_value_returns_provider_value
    result = @integer_client.fetch_integer_value(flag_key: "testing", default_value: 3)

    assert_equal(2, result)
  end

  def test_fetch_integer_value_returns_default_if_provider_raises
    result = @raising_client.fetch_integer_value(flag_key: "testing", default_value: 3)

    assert_equal(3, result)
  end

  def test_fetch_float_value_returns_provider_value
    result = @client.fetch_float_value(flag_key: "testing", default_value: 3.2)

    assert_in_delta(2.4, result)
  end

  def test_fetch_float_value_returns_default_if_provider_raises
    result = @raising_client.fetch_float_value(flag_key: "testing", default_value: 3.2)

    assert_in_delta(3.2, result)
  end

  def test_fetch_structure_value_returns_provider_value
    result = @client.fetch_structure_value(flag_key: "testing", default_value: { "another" => "test" })

    assert_equal({ "testing" => "123" }, result)
  end

  def test_fetch_structure_value_returns_default_if_provider_raises
    result = @raising_client.fetch_structure_value(flag_key: "testing", default_value: { "another" => "test" })

    assert_equal({ "another" => "test" }, result)
  end

  def test_fetch_structure_details_returns_details
    expected_details = OpenFeatureSorbet::EvaluationDetails.new(
      flag_key: "testing",
      value: { "testing" => "123" },
      reason: "STATIC"
    )

    details = @client.fetch_structure_details(flag_key: "testing", default_value: { "another" => "test" })

    assert_equal(expected_details, details)
  end

  def test_fetch_structure_details_returns_details_when_provider_raises
    expected_details = OpenFeatureSorbet::EvaluationDetails.new(
      flag_key: "testing",
      value: { "another" => "test" },
      reason: "ERROR",
      error_code: OpenFeatureSorbet::ErrorCode::General,
      error_message: "Provider raised error: TypeError"
    )

    details = @raising_client.fetch_structure_details(flag_key: "testing", default_value: { "another" => "test" })

    assert_equal(expected_details, details)
  end

  def test_fetch_boolean_value_invokes_before_hook
    hook = TestHook.new mock: Minitest::Mock.new
    expected_hook_context = build_test_hook_context(flag_type: "Boolean", default_value: false)
    hook.mock.expect(:call, expected_hook_context, [[expected_hook_context, {}]])
    @client.fetch_boolean_value(flag_key: "testing", default_value: false, options: OpenFeatureSorbet::EvaluationOptions.new(
      hooks: [hook]
    ))
    hook.mock.verify
  end

  def test_fetch_string_value_invokes_before_hook
    hook = TestHook.new mock: Minitest::Mock.new
    expected_hook_context = build_test_hook_context(flag_type: "String", default_value: "foo")
    hook.mock.expect(:call, expected_hook_context, [[expected_hook_context, {}]])
    @client.fetch_string_value(flag_key: "testing", default_value: "foo", options: OpenFeatureSorbet::EvaluationOptions.new(
      hooks: [hook]
    ))
    hook.mock.verify
  end

  def test_fetch_integer_value_invokes_before_hook
    hook = TestHook.new mock: Minitest::Mock.new
    expected_hook_context = build_test_hook_context(flag_type: "Integer", default_value: 43)
    hook.mock.expect(:call, expected_hook_context, [[expected_hook_context, {}]])
    @client.fetch_integer_value(flag_key: "testing", default_value: 43, options: OpenFeatureSorbet::EvaluationOptions.new(
      hooks: [hook]
    ))
    hook.mock.verify
  end

  def test_fetch_number_value_invokes_before_hook
    hook = TestHook.new mock: Minitest::Mock.new
    expected_hook_context = build_test_hook_context(flag_type: "Number", default_value: 3.14)
    hook.mock.expect(:call, expected_hook_context, [[expected_hook_context, {}]])
    @client.fetch_number_value(flag_key: "testing", default_value: 3.14, options: OpenFeatureSorbet::EvaluationOptions.new(
      hooks: [hook]
    ))
    hook.mock.verify
  end

  def test_fetch_float_value_invokes_before_hook
    hook = TestHook.new mock: Minitest::Mock.new
    expected_hook_context = build_test_hook_context(flag_type: "Float", default_value: 3.14)
    hook.mock.expect(:call, expected_hook_context, [[expected_hook_context, {}]])
    @client.fetch_float_value(flag_key: "testing", default_value: 3.14, options: OpenFeatureSorbet::EvaluationOptions.new(
      hooks: [hook]
    ))
    hook.mock.verify
  end

  def test_fetch_structure_value_invokes_before_hook
    hook = TestHook.new mock: Minitest::Mock.new
    expected_hook_context = build_test_hook_context(flag_type: "Structure", default_value: { "another" => "test" })
    hook.mock.expect(:call, expected_hook_context, [[expected_hook_context, {}]])
    @client.fetch_structure_value(flag_key: "testing", default_value: { "another" => "test" },
                                  options: OpenFeatureSorbet::EvaluationOptions.new(
                                    hooks: [hook]
                                  ))
    hook.mock.verify
  end

  private

  def build_test_hook_context(flag_type:, default_value:)
    OpenFeatureSorbet::HookContext.new(flag_key: "testing",
                                       flag_type: flag_type,
                                       evaluation_context: OpenFeatureSorbet::EvaluationContext.new,
                                       default_value: default_value,
                                       client_metadata: @client.client_metadata,
                                       provider_metadata: @client_provider.metadata)
  end
end
