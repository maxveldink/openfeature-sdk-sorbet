# typed: strict
# frozen_string_literal: true

module OpenFeatureSorbet
  # Possible error codes
  class ErrorCode < T::Enum
    enums do
      ProviderNotReady = new("PROVIDER_NOT_READY")
      FlagNotFound = new("FLAG_NOT_FOUND")
      ParseError = new("PARSE_ERROR")
      TypeMismatch = new("TYPE_MISMATCH")
      TargetingKeyMissing = new("TARGETING_KEY_MISSING")
      InvalidContext = new("INVALID_CONTEXT")
      General = new("GENERAL")
    end
  end
end
