# typed: strict
# frozen_string_literal: true

require "date"

module OpenFeatureSorbet
  # Provides ambient information for the purposes of flag evaluation.
  # Currently does not meet specification!
  class EvaluationContext < T::Struct
    extend T::Sig

    include T::Struct::ActsAsComparable

    const :targeting_key, T.nilable(String), default: nil
    const :fields, T::Hash[T.untyped, T.untyped], default: {}

    sig { params(method_name: Symbol).returns(T::Boolean) }
    def respond_to_missing?(method_name)
      fields.key?(method_name.to_s)
    end

    sig { params(method_name: Symbol).returns(T.untyped) }
    def method_missing(method_name)
      fields.fetch(method_name.to_s, nil)
    end

    sig { params(key: String, value: T.untyped).returns(EvaluationContext) }
    def add_field(key, value)
      EvaluationContext.new(
        targeting_key: targeting_key,
        fields: fields.merge({ key => value })
      )
    end

    sig { returns(T::Hash[T.untyped, T.untyped]) }
    def to_h
      targeting_key.nil? ? fields : fields.merge("targeting_key" => targeting_key)
    end

    sig { params(overriding_context: EvaluationContext).returns(EvaluationContext) }
    def merge(overriding_context)
      EvaluationContext.new(
        targeting_key: overriding_context.targeting_key || targeting_key,
        fields: fields.merge(overriding_context.fields)
      )
    end
  end
end
