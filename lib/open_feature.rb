# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"
require "sorbet-struct-comparable"
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

# Sorbet-aware implementation of the OpenFeature specification
module OpenFeature
  extend T::Sig

  sig { params(provider: Provider).void }
  def self.set_provider(provider) # rubocop:disable Naming/AccessorMethodName
    configuration.set_provider(provider)
  end

  sig { returns(ProviderMetadata) }
  def self.provider_metadata
    configuration.provider_metadata
  end

  sig { returns(Configuration) }
  def self.configuration
    Configuration.instance
  end
end
