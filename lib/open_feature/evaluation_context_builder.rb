# typed: strict
# frozen_string_literal: true

module OpenFeature
  # Used to combine evaluation contexts from different sources
  class EvaluationContextBuilder
    extend T::Sig

    sig do
      params(
        global_context: T.nilable(EvaluationContext),
        client_context: T.nilable(EvaluationContext),
        invocation_context: T.nilable(EvaluationContext)
      ).returns(T.nilable(EvaluationContext))
    end
    def call(global_context:, client_context:, invocation_context:)
      available_contexts = [global_context, client_context, invocation_context].compact

      return nil if available_contexts.empty?

      available_contexts.reduce(EvaluationContext.new) do |built_context, context|
        built_context.merge(context)
      end
    end
  end
end
