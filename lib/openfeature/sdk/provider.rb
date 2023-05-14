# typed: strict
# frozen_string_literal: true

module OpenFeature
  module SDK
    # Inteface that providers must implement.
    module Provider
      extend T::Sig
      extend T::Helpers
      interface!

      sig { abstract.returns(ProviderMetadata) }
      def metadata; end

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
    end
  end
end
