# typed: strict
# frozen_string_literal: true

module OpenFeature
  # Additional options to be supplied to client during flag evaluation.
  class EvaluationOptions < T::Struct
    const :hooks, T::Array[Hook], default: []
  end
end
