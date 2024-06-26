# typed: true
# frozen_string_literal: true

require "test_helper"

class EvaluationDetailsTest < Minitest::Test
  def test_from_resolution_details_builds_evaluation_details
    resolution_details = OpenFeatureSorbet::ResolutionDetails.new(
      value: "testing",
      reason: "STATIC",
      variant: "Test"
    )

    result = OpenFeatureSorbet::EvaluationDetails.from_resolution_details(resolution_details, flag_key: "testing")

    assert_equal(
      OpenFeatureSorbet::EvaluationDetails.new(
        flag_key: "testing",
        value: "testing",
        variant: "Test",
        reason: "STATIC"
      ),
      result
    )
  end

  def test_from_error_builds_evaluation_details
    result = OpenFeatureSorbet::EvaluationDetails.from_error(
      "Something bad happened!",
      flag_key: "testing",
      default_value: "fallback"
    )

    assert_equal(
      OpenFeatureSorbet::EvaluationDetails.new(
        flag_key: "testing",
        value: "fallback",
        error_code: OpenFeatureSorbet::ErrorCode::General,
        error_message: "Provider raised error: Something bad happened!",
        reason: "ERROR"
      ),
      result
    )
  end
end
