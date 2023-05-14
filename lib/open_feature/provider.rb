# typed: strict
# frozen_string_literal: true

module OpenFeature
  # Interface that providers must implement.
  module Provider
    extend T::Sig
    extend T::Helpers
    interface!

    sig { abstract.returns(ProviderMetadata) }
    def metadata; end

    sig { abstract.returns(T::Array[Hook]) }
    def hooks; end

    sig do
      abstract
        .params(
          flag_key: String,
          default_value: T::Boolean,
          context: T.nilable(EvaluationContext)
        )
        .returns(ResolutionDetails[T::Boolean])
    end
    def resolve_boolean_value(flag_key:, default_value:, context: nil); end

    sig do
      abstract
        .params(
          flag_key: String,
          default_value: String,
          context: T.nilable(EvaluationContext)
        )
        .returns(ResolutionDetails[String])
    end
    def resolve_string_value(flag_key:, default_value:, context: nil); end

    sig do
      abstract
        .params(
          flag_key: String,
          default_value: Numeric,
          context: T.nilable(EvaluationContext)
        )
        .returns(ResolutionDetails[Numeric])
    end
    def resolve_number_value(flag_key:, default_value:, context: nil); end

    sig do
      abstract
        .params(
          flag_key: String,
          default_value: T::Hash[T.untyped, T.untyped],
          context: T.nilable(EvaluationContext)
        )
        .returns(ResolutionDetails[T::Hash[T.untyped, T.untyped]])
    end
    def resolve_structure_value(flag_key:, default_value:, context: nil); end
  end
end