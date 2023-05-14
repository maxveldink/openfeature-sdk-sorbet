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

  sig { returns(ProviderMetadata) }
  def self.provider_metadata
    Configuration.instance.provider_metadata
  end
end
