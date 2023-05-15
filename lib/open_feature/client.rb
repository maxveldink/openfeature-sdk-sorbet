# typed: strict
# frozen_string_literal: true

module OpenFeature
  # Used during runtime for evaluating features.
  class Client
    extend T::Sig

    sig { returns(ClientMetadata) }
    attr_reader :client_metadata

    sig { returns(T::Array[Hook]) }
    attr_reader :hooks

    sig { params(name: T.nilable(String)).void }
    def initialize(name: nil)
      @client_metadata = T.let(ClientMetadata.new(name: name), ClientMetadata)
      @hooks = T.let([], T::Array[Hook])
    end

    sig { params(hooks: T.any(Hook, T::Array[Hook])).void }
    def add_hooks(hooks)
      @hooks.concat(Array(hooks))
    end
  end
end
