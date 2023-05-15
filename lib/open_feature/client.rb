# typed: strict
# frozen_string_literal: true

module OpenFeature
  # Used during runtime for evaluating features.
  class Client < T::Struct
    const :client_metadata, ClientMetadata
  end
end
