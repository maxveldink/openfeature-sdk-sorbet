# typed: strict
# frozen_string_literal: true

module OpenFeature
  # Information about resolved value, created by a Provider.
  class EvaluationDetails < T::Struct
    extend T::Generic

    include T::Struct::ActsAsComparable

    Value = type_member
    SelfValue = type_template

    const :flag_key, String
    const :value, Value
    const :error_code, T.nilable(ErrorCode)
    const :error_message, T.nilable(String)
    const :reason, T.nilable(String)
    const :variant, T.nilable(String)
    const :flag_metadata, T.nilable(FlagMetadata)

    class << self
      extend T::Sig

      sig { params(details: ResolutionDetails[SelfValue], flag_key: String).returns(EvaluationDetails[SelfValue]) }
      def from_resolution_details(details, flag_key:)
        EvaluationDetails.new(
          flag_key:,
          value: details.value,
          error_code: details.error_code,
          error_message: details.error_message,
          variant: details.variant,
          reason: details.reason,
          flag_metadata: details.flag_metadata
        )
      end

      sig do
        params(
          error_message: String,
          flag_key: String,
          default_value: SelfValue
        ).returns(EvaluationDetails[SelfValue])
      end
      def from_error(error_message, flag_key:, default_value:)
        EvaluationDetails.new(
          flag_key:,
          value: default_value,
          error_code: ErrorCode::General,
          error_message: "Provider raised error: #{error_message}",
          reason: "ERROR"
        )
      end
    end
  end
end
