# typed: true
# frozen_string_literal: true

require "test_helper"

class EvaluationContextBuilderTest < Minitest::Test
  def setup
    @builder = OpenFeatureSorbet::EvaluationContextBuilder.new
    @global_context = OpenFeatureSorbet::EvaluationContext.new(targeting_key: "global", fields: { "global" => "key" })
    @client_context = OpenFeatureSorbet::EvaluationContext.new(targeting_key: "client", fields: { "client" => "key" })
    @invocation_context = OpenFeatureSorbet::EvaluationContext.new(targeting_key: "invocation",
                                                                   fields: { "invoke" => "key" })
  end

  def test_no_available_contexts_returns_nil
    result = @builder.call(global_context: nil, client_context: nil, invocation_context: nil)

    assert_nil(result)
  end

  def test_only_global_context_returns_global_context
    result = @builder.call(global_context: @global_context, client_context: nil, invocation_context: nil)

    assert_equal(
      OpenFeatureSorbet::EvaluationContext.new(
        targeting_key: "global",
        fields: { "global" => "key" }
      ),
      result
    )
  end

  def test_only_client_context_returns_client_context
    result = @builder.call(global_context: nil, client_context: @client_context, invocation_context: nil)

    assert_equal(
      OpenFeatureSorbet::EvaluationContext.new(
        targeting_key: "client",
        fields: { "client" => "key" }
      ),
      result
    )
  end

  def test_only_invocation_context_returns_invocation_context
    result = @builder.call(global_context: nil, client_context: nil, invocation_context: @invocation_context)

    assert_equal(
      OpenFeatureSorbet::EvaluationContext.new(
        targeting_key: "invocation",
        fields: { "invoke" => "key" }
      ),
      result
    )
  end

  def test_only_client_and_global_contexts_returns_merged_context
    result = @builder.call(global_context: @global_context, client_context: @client_context, invocation_context: nil)

    assert_equal(
      OpenFeatureSorbet::EvaluationContext.new(
        targeting_key: "client",
        fields: { "global" => "key", "client" => "key" }
      ),
      result
    )
  end

  def test_only_client_and_invocation_contexts_returns_merged_context
    result = @builder.call(
      global_context: nil,
      client_context: @client_context,
      invocation_context: @invocation_context
    )

    assert_equal(
      OpenFeatureSorbet::EvaluationContext.new(
        targeting_key: "invocation",
        fields: { "client" => "key", "invoke" => "key" }
      ),
      result
    )
  end

  def test_only_global_and_invocation_contexts_returns_merged_context
    result = @builder.call(
      global_context: @global_context,
      client_context: nil,
      invocation_context: @invocation_context
    )

    assert_equal(
      OpenFeatureSorbet::EvaluationContext.new(
        targeting_key: "invocation",
        fields: { "global" => "key", "invoke" => "key" }
      ),
      result
    )
  end

  def test_all_contexts_returns_merged_context
    result = @builder.call(
      global_context: @global_context,
      client_context: @client_context,
      invocation_context: @invocation_context
    )

    assert_equal(
      OpenFeatureSorbet::EvaluationContext.new(
        targeting_key: "invocation",
        fields: { "global" => "key", "client" => "key", "invoke" => "key" }
      ),
      result
    )
  end
end
