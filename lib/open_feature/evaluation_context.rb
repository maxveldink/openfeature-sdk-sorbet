# typed: strict
# frozen_string_literal: true

require "date"

module OpenFeature
  # Provides ambient information for the purposes of flag evaluation.
  # Currently does not meet specification!
  class EvaluationContext < T::Struct
    extend T::Sig

    include T::Struct::ActsAsComparable

    FieldValueType = T.type_alias { T.any(T::Boolean, String, Numeric, DateTime, Structure) }

    const :targeting_key, T.nilable(String), default: nil
    const :fields, T::Hash[String, FieldValueType], default: {}

    sig { params(method_name: Symbol).returns(T::Boolean) }
    def respond_to_missing?(method_name)
      fields.key?(method_name.to_s)
    end

    sig { params(method_name: Symbol).returns(T.nilable(FieldValueType)) }
    def method_missing(method_name)
      fields.fetch(method_name.to_s, nil)
    end

    sig { params(key: String, value: FieldValueType).returns(EvaluationContext) }
    def add_field(key, value)
      EvaluationContext.new(
        targeting_key: targeting_key,
        fields: fields.merge({ key => value })
      )
    end

    sig { returns(T::Hash[String, FieldValueType]) }
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
