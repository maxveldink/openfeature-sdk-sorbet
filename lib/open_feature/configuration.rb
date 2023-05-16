# typed: strict
# frozen_string_literal: true

require "singleton"

module OpenFeature
  # Singleton class that supports global configuration for OpenFeature.
  # Should not be interacted with directly; rather, favor interacting
  # with methods defined on the `OpenFeature` module.
  class Configuration
    extend T::Sig

    include Singleton

    sig { returns(Provider) }
    attr_reader :provider

    sig { returns(T.nilable(EvaluationContext)) }
    attr_reader :evaluation_context

    sig { returns(T::Array[Hook]) }
    attr_reader :hooks

    sig { void }
    def initialize
      @provider = T.let(NoOpProvider.new, Provider)
      @evaluation_context = T.let(nil, T.nilable(EvaluationContext))
      @hooks = T.let([], T::Array[Hook])
    end

    sig { returns(ProviderMetadata) }
    def provider_metadata
      provider.metadata
    end

    sig { params(provider: Provider).void }
    def set_provider(provider) # rubocop:disable Naming/AccessorMethodName
      @provider = provider
    end

    sig { params(context: EvaluationContext).void }
    def set_evaluation_context(context) # rubocop:disable Naming/AccessorMethodName
      @evaluation_context = context
    end

    sig { params(hooks: T.any(Hook, T::Array[Hook])).void }
    def add_hooks(hooks)
      @hooks.concat(Array(hooks))
    end

    sig { void }
    def clear_hooks!
      @hooks = []
    end
  end
end
