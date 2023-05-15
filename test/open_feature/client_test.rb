# typed: true
# frozen_string_literal: true

require_relative "../support/test_provider"

class ClientTest < Minitest::Test
  def setup
    @client = OpenFeature::Client.new(provider: TestProvider.new, name: "testing")
    @raising_client = OpenFeature::Client.new(provider: TestProvider.new(raising: true))
    @integer_client = OpenFeature::Client.new(provider: TestProvider.new(number_value: 2))
  end

  def test_is_initialized_properly
    assert_equal("testing", @client.client_metadata.name)
    assert_empty(@client.hooks)
  end

  def test_hooks_can_be_added
    @client.add_hooks(OpenFeature::Hook.new)
    @client.add_hooks([OpenFeature::Hook.new, OpenFeature::Hook.new])

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

  def test_fetch_string_value_returns_provider_value
    result = @client.fetch_string_value(flag_key: "testing", default_value: "fallback")

    assert_equal("testing", result)
  end

  def test_fetch_string_value_returns_default_if_provider_raises
    result = @raising_client.fetch_string_value(flag_key: "testing", default_value: "fallback")

    assert_equal("fallback", result)
  end

  def test_fetch_number_value_returns_provider_value
    result = @client.fetch_number_value(flag_key: "testing", default_value: 3.2)

    assert_in_delta(2.4, result)
  end

  def test_fetch_number_value_returns_default_if_provider_raises
    result = @raising_client.fetch_number_value(flag_key: "testing", default_value: 3.2)

    assert_in_delta(3.2, result)
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
end
