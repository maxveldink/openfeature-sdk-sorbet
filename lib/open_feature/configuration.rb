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
    attr_accessor :provider

    sig { returns(T.nilable(EvaluationContext)) }
    attr_accessor :evaluation_context

    sig { returns(T::Array[Hook]) }
    attr_accessor :hooks

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

    sig { void }
    def reset!
      @provider = OpenFeature::NoOpProvider.new
      @hooks = []
      @evaluation_context = nil
    end
  end
end
