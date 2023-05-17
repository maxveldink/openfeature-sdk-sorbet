# typed: true
# frozen_string_literal: true

require "test_helper"

class EvaluationContextTest < Minitest::Test
  def setup
    @evaluation_context_without_targeting_key = OpenFeature::EvaluationContext.new(
      fields: { "testing" => "a value", "something" => "different" }
    )
    @evaluation_context_with_targeting_key = OpenFeature::EvaluationContext.new(
      targeting_key: "abc",
      fields: { "testing" => "another value" }
    )
  end

  def test_method_missing_returns_field_value_if_found
    assert_equal("a value", @evaluation_context_without_targeting_key.testing)
  end

  def test_method_missing_returns_nil_if_not_found
    assert_nil(@evaluation_context_without_targeting_key.not_here)
  end

  def test_add_field_returns_new_context_instance
    new_context = @evaluation_context_without_targeting_key.add_field("another", "thing")

    refute_equal(@evaluation_context_without_targeting_key, new_context)
    assert_equal("thing", new_context.another)
  end

  def test_to_h_returns_hash_of_all_fields_without_targeting_key
    assert_equal(
      { "testing" => "a value", "something" => "different" },
      @evaluation_context_without_targeting_key.to_h
    )
  end

  def test_to_h_returns_hash_of_all_fields_with_targeting_key
    assert_equal(
      { "testing" => "another value", "targeting_key" => "abc" },
      @evaluation_context_with_targeting_key.to_h
    )
  end

  def test_merge_overrides_values_with_given_context
    new_context = @evaluation_context_without_targeting_key.merge(@evaluation_context_with_targeting_key)

    assert_equal(
      OpenFeature::EvaluationContext.new(
        targeting_key: "abc",
        fields: { "testing" => "another value", "something" => "different" }
      ),
      new_context
    )
  end
end
