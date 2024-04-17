# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"
require "sorbet-struct-comparable"
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

# Sorbet-aware implementation of the OpenFeature specification
module OpenFeatureSorbet
  class << self
    extend T::Sig

    sig { returns(ProviderMetadata) }
    def provider_metadata
      configuration.provider_metadata
    end

    sig { params(provider: Provider).void }
    def set_provider(provider) # rubocop:disable Naming/AccessorMethodName
      configuration.provider.shutdown
      provider.init(context: configuration.evaluation_context || EvaluationContext.new)
      configuration.provider = provider
    end

    sig { params(context: EvaluationContext).void }
    def set_evaluation_context(context) # rubocop:disable Naming/AccessorMethodName
      configuration.evaluation_context = context
    end

    sig { params(hooks: T.any(Hook, T::Array[Hook])).void }
    def add_hooks(hooks)
      configuration.hooks.concat(Array(hooks))
    end

    sig do
      params(
        name: T.nilable(String),
        evaluation_context: T.nilable(EvaluationContext),
        hooks: T.nilable(T.any(Hook, T::Array[Hook]))
      ).returns(Client)
    end
    def create_client(name: nil, evaluation_context: nil, hooks: nil)
      Client.new(
        provider: configuration.provider,
        name: name,
        evaluation_context: evaluation_context,
        hooks: Array(hooks)
      )
    end

    sig { void }
    def shutdown
      configuration.provider.shutdown
    end

    sig { returns(Configuration) }
    def configuration
      Configuration.instance
    end
  end
end
