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
      configuration.set_provider(provider)
    end

    sig { params(hooks: T.any(Hook, T::Array[Hook])).void }
    def add_hooks(hooks)
      configuration.add_hooks(hooks)
    end

    sig { returns(Configuration) }
    def configuration
      Configuration.instance
    end
  end
end
