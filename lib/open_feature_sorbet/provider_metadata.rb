# typed: strict
# frozen_string_literal: true

module OpenFeatureSorbet
  # Defines information about a Provider.
  class ProviderMetadata < T::Struct
    include T::Struct::ActsAsComparable

    const :name, String
  end
end
