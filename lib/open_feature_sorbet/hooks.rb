# typed: strict
# frozen_string_literal: true

module OpenFeatureSorbet
  # Represents full set of hooks with helper methods for filtering and sequencing each subtype
  class Hooks < T::Struct
    extend T::Generic
    extend T::Sig
    const :global, T::Array[Hook], default: []
    const :provider, T::Array[Hook], default: []
    const :client, T::Array[Hook], default: []
    const :invocation, T::Array[Hook], default: []

    # See Requirement 4.4.2
    # TODO: when there is >1 subtype of hook will need to filter and not simply re-cast
    #   ACHTUNG! T.cast is safe for now but will need to be updated after ^
    sig { returns(T::Array[Hook::BeforeHook]) }
    def before
      T.cast(global + client + invocation + provider, T::Array[Hook::BeforeHook])
    end
  end
end
