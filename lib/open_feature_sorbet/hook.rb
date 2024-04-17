# typed: strict
# frozen_string_literal: true

module OpenFeatureSorbet
  # See https://openfeature.dev/specification/sections/hooks
  # We model Hooks as a simple ADT
  module Hook
    extend T::Sig
    extend T::Helpers
    interface!
    sealed!

    # See Requirement 4.3.2 - 4.3.4
    class BeforeHook
      include Hook
      extend T::Sig
      extend T::Helpers
      include OpenFeatureSorbet::Hook
      abstract!
      sig do
        abstract.params(context: OpenFeatureSorbet::HookContext[T.untyped],
                        hints: T::Hash[String, T.untyped]).returns(OpenFeatureSorbet::EvaluationContext)
      end
      def call(context:, hints:); end

      class << self
        extend T::Sig

        sig do
          params(hooks: Hooks, context: OpenFeatureSorbet::HookContext[T.untyped],
                 hints: T::Hash[String, T.untyped]).returns(OpenFeatureSorbet::EvaluationContext)
        end
        def call(hooks:, context:, hints:)
          context.evaluation_context.merge(
            hooks.before.reduce(context.evaluation_context) do |evaluation_context, hook|
              hook.call(
                context: context.with_new_evaluation_context(evaluation_context),
                hints: hints
              )
            end
          )
        end
      end
    end
  end
end
