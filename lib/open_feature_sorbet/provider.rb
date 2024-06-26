# typed: strict
# frozen_string_literal: true

module OpenFeatureSorbet
  # Interface that providers must implement.
  class Provider
    extend T::Sig
    extend T::Helpers
    abstract!

    sig { returns(ProviderStatus) }
    attr_reader :status

    sig { params(status: ProviderStatus).void }
    def initialize(status = ProviderStatus::Ready)
      @status = status
    end

    sig { overridable.params(context: EvaluationContext).void }
    def init(context:); end

    sig { abstract.returns(ProviderMetadata) }
    def metadata; end

    sig { abstract.returns(T::Array[Hook]) }
    def hooks; end

    sig { overridable.void }
    def shutdown; end

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
          default_value: Structure,
          context: T.nilable(EvaluationContext)
        )
        .returns(ResolutionDetails[Structure])
    end
    def resolve_structure_value(flag_key:, default_value:, context: nil); end
  end
end
