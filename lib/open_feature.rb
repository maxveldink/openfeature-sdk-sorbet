# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"
require "sorbet-struct-comparable"
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

# Sorbet-aware implementation of the OpenFeature specification
module OpenFeature
  class << self
    extend T::Sig

    sig { returns(ProviderMetadata) }
    def provider_metadata
      configuration.provider_metadata
    end

    sig { params(provider: Provider).void }
    def set_provider(provider) # rubocop:disable Naming/AccessorMethodName
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

    sig { params(name: T.nilable(String)).returns(Client) }
    def create_client(name: nil)
      Client.new(provider: configuration.provider, name: name)
    end

    sig { returns(Configuration) }
    def configuration
      Configuration.instance
    end
  end
end
