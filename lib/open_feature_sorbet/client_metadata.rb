# typed: strict
# frozen_string_literal: true

module OpenFeatureSorbet
  # Defines information about a Client.
  class ClientMetadata < T::Struct
    include T::Struct::ActsAsComparable
    const :name, T.nilable(String)
  end
end
