# typed: strict
# frozen_string_literal: true

module OpenFeature
  # Used during runtime for evaluating features.
  class Client
    extend T::Sig

    sig { returns(ClientMetadata) }
    attr_reader :client_metadata

    sig { returns(T::Array[Hook]) }
    attr_reader :hooks

    sig { params(provider: Provider, name: T.nilable(String)).void }
    def initialize(provider:, name: nil)
      @provider = provider
      @client_metadata = T.let(ClientMetadata.new(name: name), ClientMetadata)
      @hooks = T.let([], T::Array[Hook])
    end

    sig { params(hooks: T.any(Hook, T::Array[Hook])).void }
    def add_hooks(hooks)
      @hooks.concat(Array(hooks))
    end

    sig do
      params(
        flag_key: String,
        default_value: T::Boolean,
        context: T.nilable(EvaluationContext),
        options: T.nilable(EvaluationOptions)
      ).returns(T::Boolean)
    end
    def fetch_boolean_value(flag_key:, default_value:, context: nil, options: nil) # rubocop:disable Lint/UnusedMethodArgument
      provider.resolve_boolean_value(flag_key: flag_key, default_value: default_value, context: context).value
    rescue StandardError
      default_value
    end

    sig do
      params(
        flag_key: String,
        default_value: T::Boolean,
        context: T.nilable(EvaluationContext),
        options: T.nilable(EvaluationOptions)
      ).returns(EvaluationDetails[T::Boolean])
    end
    def fetch_boolean_details(flag_key:, default_value:, context: nil, options: nil) # rubocop:disable Lint/UnusedMethodArgument
      details = provider.resolve_boolean_value(flag_key: flag_key, default_value: default_value, context: context)

      EvaluationDetails.from_resolution_details(details, flag_key: flag_key)
    rescue StandardError => e
      EvaluationDetails.from_error(e.message, flag_key: flag_key, default_value: default_value)
    end

    sig do
      params(
        flag_key: String,
        default_value: String,
        context: T.nilable(EvaluationContext),
        options: T.nilable(EvaluationOptions)
      ).returns(String)
    end
    def fetch_string_value(flag_key:, default_value:, context: nil, options: nil) # rubocop:disable Lint/UnusedMethodArgument
      provider.resolve_string_value(flag_key: flag_key, default_value: default_value, context: context).value
    rescue StandardError
      default_value
    end

    sig do
      params(
        flag_key: String,
        default_value: String,
        context: T.nilable(EvaluationContext),
        options: T.nilable(EvaluationOptions)
      ).returns(EvaluationDetails[String])
    end
    def fetch_string_details(flag_key:, default_value:, context: nil, options: nil) # rubocop:disable Lint/UnusedMethodArgument
      details = provider.resolve_string_value(flag_key: flag_key, default_value: default_value, context: context)

      EvaluationDetails.from_resolution_details(details, flag_key: flag_key)
    rescue StandardError => e
      EvaluationDetails.from_error(e.message, flag_key: flag_key, default_value: default_value)
    end

    sig do
      params(
        flag_key: String,
        default_value: Numeric,
        context: T.nilable(EvaluationContext),
        options: T.nilable(EvaluationOptions)
      ).returns(Numeric)
    end
    def fetch_number_value(flag_key:, default_value:, context: nil, options: nil) # rubocop:disable Lint/UnusedMethodArgument
      provider.resolve_number_value(flag_key: flag_key, default_value: default_value, context: context).value
    rescue StandardError
      default_value
    end

    sig do
      params(
        flag_key: String,
        default_value: Numeric,
        context: T.nilable(EvaluationContext),
        options: T.nilable(EvaluationOptions)
      ).returns(EvaluationDetails[Numeric])
    end
    def fetch_number_details(flag_key:, default_value:, context: nil, options: nil) # rubocop:disable Lint/UnusedMethodArgument
      details = provider.resolve_number_value(flag_key: flag_key, default_value: default_value, context: context)

      EvaluationDetails.from_resolution_details(details, flag_key: flag_key)
    rescue StandardError => e
      EvaluationDetails.from_error(e.message, flag_key: flag_key, default_value: default_value)
    end

    sig do
      params(
        flag_key: String,
        default_value: Integer,
        context: T.nilable(EvaluationContext),
        options: T.nilable(EvaluationOptions)
      ).returns(Integer)
    end
    def fetch_integer_value(flag_key:, default_value:, context: nil, options: nil) # rubocop:disable Lint/UnusedMethodArgument
      provider.resolve_number_value(flag_key: flag_key, default_value: default_value, context: context).value.to_i
    rescue StandardError
      default_value
    end

    sig do
      params(
        flag_key: String,
        default_value: Float,
        context: T.nilable(EvaluationContext),
        options: T.nilable(EvaluationOptions)
      ).returns(Float)
    end
    def fetch_float_value(flag_key:, default_value:, context: nil, options: nil) # rubocop:disable Lint/UnusedMethodArgument
      provider.resolve_number_value(flag_key: flag_key, default_value: default_value, context: context).value.to_f
    rescue StandardError
      default_value
    end

    sig do
      params(
        flag_key: String,
        default_value: Structure,
        context: T.nilable(EvaluationContext),
        options: T.nilable(EvaluationOptions)
      ).returns(Structure)
    end
    def fetch_structure_value(flag_key:, default_value:, context: nil, options: nil) # rubocop:disable Lint/UnusedMethodArgument
      provider.resolve_structure_value(flag_key: flag_key, default_value: default_value, context: context).value
    rescue StandardError
      default_value
    end

    sig do
      params(
        flag_key: String,
        default_value: Structure,
        context: T.nilable(EvaluationContext),
        options: T.nilable(EvaluationOptions)
      ).returns(EvaluationDetails[Structure])
    end
    def fetch_structure_details(flag_key:, default_value:, context: nil, options: nil) # rubocop:disable Lint/UnusedMethodArgument
      details = provider.resolve_structure_value(flag_key: flag_key, default_value: default_value, context: context)

      EvaluationDetails.from_resolution_details(details, flag_key: flag_key)
    rescue StandardError => e
      EvaluationDetails.from_error(e.message, flag_key: flag_key, default_value: default_value)
    end

    private

    sig { returns(Provider) }
    attr_reader :provider
  end
end
