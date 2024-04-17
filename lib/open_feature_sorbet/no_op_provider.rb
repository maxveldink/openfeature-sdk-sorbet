# typed: strict
# frozen_string_literal: true

module OpenFeatureSorbet
  # Default provider when initializing OpenFeature.
  # Always returns the default value given.
  # This will result in a TypeError if the given default value does not have the correct type.
  class NoOpProvider < Provider
    extend T::Sig

    sig { override.returns(ProviderMetadata) }
    attr_reader :metadata

    sig { override.returns(T::Array[Hook]) }
    attr_reader :hooks

    sig { void }
    def initialize
      @metadata = T.let(ProviderMetadata.new(name: "No Op Provider"), ProviderMetadata)
      @hooks = T.let([], T::Array[Hook])
      super()
    end

    sig do
      override
        .params(
          flag_key: String,
          default_value: T::Boolean,
          context: T.nilable(EvaluationContext)
        )
        .returns(ResolutionDetails[T::Boolean])
    end
    def resolve_boolean_value(flag_key:, default_value:, context: nil)
      ResolutionDetails.new(value: default_value, reason: "DEFAULT")
    end

    sig do
      override
        .params(
          flag_key: String,
          default_value: String,
          context: T.nilable(EvaluationContext)
        )
        .returns(ResolutionDetails[String])
    end
    def resolve_string_value(flag_key:, default_value:, context: nil)
      ResolutionDetails.new(value: default_value, reason: "DEFAULT")
    end

    sig do
      override
        .params(
          flag_key: String,
          default_value: Numeric,
          context: T.nilable(EvaluationContext)
        )
        .returns(ResolutionDetails[Numeric])
    end
    def resolve_number_value(flag_key:, default_value:, context: nil)
      ResolutionDetails.new(value: default_value, reason: "DEFAULT")
    end

    sig do
      override
        .params(
          flag_key: String,
          default_value: Structure,
          context: T.nilable(EvaluationContext)
        )
        .returns(ResolutionDetails[Structure])
    end
    def resolve_structure_value(flag_key:, default_value:, context: nil)
      ResolutionDetails.new(value: default_value, reason: "DEFAULT")
    end
  end
end
