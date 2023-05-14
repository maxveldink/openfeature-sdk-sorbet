# typed: strict
# frozen_string_literal: true

module OpenFeature
  # Default provider when initializing OpenFeature.
  # Always returns the default value given.
  # This will result in a TypeError if the given default value does not have the correct type.
  class NoOpProvider
    extend T::Sig

    sig { returns(ProviderMetadata) }
    attr_reader :metadata

    sig { void }
    def initialize
      @metadata = T.let(ProviderMetadata.new(name: "No Op Provider"), ProviderMetadata)
    end
  end
end
