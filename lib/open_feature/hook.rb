# typed: strict
# frozen_string_literal: true

module OpenFeature
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
      include OpenFeature::Hook
      abstract!
      sig do
        abstract.params(context: OpenFeature::HookContext[T.untyped],
                        hints: T::Hash[String, T.untyped]).returns(OpenFeature::EvaluationContext)
      end
      def call(context:, hints:); end

      class << self
        extend T::Sig

        sig do
          params(hooks: T::Array[OpenFeature::Hook], context: OpenFeature::HookContext[T.untyped],
                 hints: T::Hash[String, T.untyped]).returns(OpenFeature::EvaluationContext)
        end
        def call(hooks:, context:, hints:)
          context.evaluation_context.merge(
            filtered_to_type(hooks).reduce(context.evaluation_context) do |evaluation_context, hook|
              hook.call(
                context: context.with_new_evaluation_context(evaluation_context),
                hints: hints
              )
            end
          )
        end

        private

        # The following function is a bit boilerplatey, perhaps there's a better way?
        sig { params(hooks: T::Array[OpenFeature::Hook]).returns(T::Array[OpenFeature::Hook::BeforeHook]) }
        def filtered_to_type(hooks)
          hooks
            .flat_map do |hook|
              case hook
              when OpenFeature::Hook::BeforeHook
                [T.let(hook, OpenFeature::Hook::BeforeHook)]
              else []
              end
            end
        end
      end
    end

    # Todo
    class AfterHook
      include Hook
    end
  end
end
