# typed: strict
# frozen_string_literal: true

module OpenFeature
  module SDK
    # Defines information about a Provider.
    class ProviderMetadata < T::Struct
      const :name, String
    end
  end
end