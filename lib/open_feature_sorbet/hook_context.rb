# typed: strict
# frozen_string_literal: true

module OpenFeatureSorbet
  # See https://openfeature.dev/specification/sections/hooks#41-hook-context
  # See Requirement 4.1.1, 4.1.3, 4.1.4
  # TODO: Requirement 4.1.2
  class HookContext < T::Struct
    extend T::Generic
    extend T::Sig

    include T::Struct::ActsAsComparable

    Value = type_member
    const :flag_key, String
    const :flag_type, String
    const :evaluation_context, EvaluationContext
    const :default_value, Value
    const :client_metadata, ClientMetadata
    const :provider_metadata, ProviderMetadata

    # Needed as opposed to .with due to https://sorbet.org/docs/tstruct#from_hash-gotchas
    sig { params(new_context: EvaluationContext).returns(HookContext[Value]) }
    def with_new_evaluation_context(new_context)
      OpenFeatureSorbet::HookContext.new(flag_key: flag_key, flag_type: flag_type, default_value: default_value,
                                         evaluation_context: new_context, client_metadata: client_metadata,
                                         provider_metadata: provider_metadata)
    end
  end
end
