# typed: strict
# frozen_string_literal: true

module OpenFeature
  # Indicates what state a provider is in
  class ProviderStatus < T::Enum
    enums do
      NotReady = new
      Ready = new
      Error = new
    end
  end
end
