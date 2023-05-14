# typed: strict
# frozen_string_literal: true

module OpenFeature
  module SDK
    FlagMetadata = T.type_alias { T::Hash[String, T.any(T::Boolean, String, Numeric)] }
  end
end
