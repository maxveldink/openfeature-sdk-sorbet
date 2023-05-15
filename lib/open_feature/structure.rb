# typed: strict
# frozen_string_literal: true

module OpenFeature
  Structure = T.type_alias { T.any(T::Array[T.untyped], T::Hash[T.untyped, T.untyped]) }
end
