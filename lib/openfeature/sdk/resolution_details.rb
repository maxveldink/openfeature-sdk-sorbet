# typed: strict
# frozen_string_literal: true

module OpenFeature
  module SDK
    # Information about resolved value, created by a Provider.
    class ResolutionDetails < T::Struct
      extend T::Generic

      Value = type_member

      const :value, Value
      const :error_code, T.nilable(ErrorCode)
      const :error_message, T.nilable(String)
      const :reason, T.nilable(String)
      const :variant, T.nilable(String)
      const :reason, T.nilable(String)
      const :flag_metadata, T.nilable(FlagMetadata)
    end
  end
end