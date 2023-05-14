# typed: strict
# frozen_string_literal: true

module OpenFeature
  module SDK
    # Provides ambient information for the purposes of flag evaluation.
    # Currently does not meet specification!
    class EvaluationContext < T::Struct
      const :targeting_key, T.nilable(String)
    end
  end
end
