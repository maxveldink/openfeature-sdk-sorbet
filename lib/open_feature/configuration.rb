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

    sig { void }
    def initialize
      @provider = T.let(NoOpProvider.new, Provider)
    end

    sig { returns(ProviderMetadata) }
    def provider_metadata
      provider.metadata
    end

    sig { params(provider: Provider).void }
    def set_provider(provider) # rubocop:disable Naming/AccessorMethodName
      @provider = provider
    end

    private

    sig { returns(Provider) }
    attr_reader :provider
  end
end
