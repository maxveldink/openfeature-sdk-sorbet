# typed: strict
# frozen_string_literal: true

module OpenFeatureSorbet
  Structure = T.type_alias { T.any(T::Array[T.untyped], T::Hash[T.untyped, T.untyped]) }
end
