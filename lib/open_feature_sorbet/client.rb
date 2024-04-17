# typed: strict
# frozen_string_literal: true

module OpenFeatureSorbet
  # Used during runtime for evaluating features.
  class Client
    extend T::Sig

    sig { returns(ClientMetadata) }
    attr_reader :client_metadata

    sig { returns(T.nilable(EvaluationContext)) }
    attr_accessor :evaluation_context

    sig { returns(T::Array[Hook]) }
    attr_reader :hooks

    sig do
      params(
        provider: Provider,
        name: T.nilable(String),
        evaluation_context: T.nilable(EvaluationContext),
        hooks: T::Array[Hook]
      ).void
    end
    def initialize(provider:, name: nil, evaluation_context: nil, hooks: [])
      @provider = provider
      @client_metadata = T.let(ClientMetadata.new(name: name), ClientMetadata)
      @evaluation_context = evaluation_context
      @hooks = hooks
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
    def fetch_boolean_value(flag_key:, default_value:, context: nil, options: nil)
      evaluated_context = build_context_with_before_hooks(flag_key: flag_key, default_value: default_value,
                                                          invocation_context: context, options: options,
                                                          flag_type: "Boolean")
      provider.resolve_boolean_value(flag_key: flag_key, default_value: default_value, context: evaluated_context)
              .value
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
      details = provider.resolve_boolean_value(
        flag_key: flag_key,
        default_value: default_value,
        context: build_context(context)
      )

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
    def fetch_string_value(flag_key:, default_value:, context: nil, options: nil)
      evaluated_context = build_context_with_before_hooks(flag_key: flag_key, default_value: default_value,
                                                          invocation_context: context, options: options,
                                                          flag_type: "String")
      provider
        .resolve_string_value(flag_key: flag_key, default_value: default_value, context: evaluated_context)
        .value
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
      details = provider.resolve_string_value(
        flag_key: flag_key,
        default_value: default_value,
        context: build_context(context)
      )

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
    def fetch_number_value(flag_key:, default_value:, context: nil, options: nil)
      evaluated_context = build_context_with_before_hooks(flag_key: flag_key, default_value: default_value,
                                                          invocation_context: context, options: options,
                                                          flag_type: "Number")
      provider
        .resolve_number_value(flag_key: flag_key, default_value: default_value, context: evaluated_context)
        .value
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
      details = provider.resolve_number_value(
        flag_key: flag_key,
        default_value: default_value,
        context: build_context(context)
      )

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
    def fetch_integer_value(flag_key:, default_value:, context: nil, options: nil)
      evaluated_context = build_context_with_before_hooks(flag_key: flag_key, default_value: default_value,
                                                          invocation_context: context, options: options,
                                                          flag_type: "Integer")
      provider
        .resolve_number_value(flag_key: flag_key, default_value: default_value, context: evaluated_context)
        .value
        .to_i
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
    def fetch_float_value(flag_key:, default_value:, context: nil, options: nil)
      evaluated_context = build_context_with_before_hooks(flag_key: flag_key, default_value: default_value,
                                                          invocation_context: context, options: options,
                                                          flag_type: "Float")
      provider
        .resolve_number_value(flag_key: flag_key, default_value: default_value, context: evaluated_context)
        .value
        .to_f
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
    def fetch_structure_value(flag_key:, default_value:, context: nil, options: nil)
      evaluated_context = build_context_with_before_hooks(flag_key: flag_key, default_value: default_value,
                                                          invocation_context: context, options: options,
                                                          flag_type: "Structure")
      provider
        .resolve_structure_value(flag_key: flag_key, default_value: default_value, context: evaluated_context)
        .value
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
      details = provider.resolve_structure_value(
        flag_key: flag_key,
        default_value: default_value,
        context: build_context(context)
      )

      EvaluationDetails.from_resolution_details(details, flag_key: flag_key)
    rescue StandardError => e
      EvaluationDetails.from_error(e.message, flag_key: flag_key, default_value: default_value)
    end

    private

    sig { returns(Provider) }
    attr_reader :provider

    sig do
      type_parameters(:U).params(
        flag_key: String,
        default_value: T.type_parameter(:U),
        invocation_context: T.nilable(EvaluationContext),
        options: T.nilable(EvaluationOptions),
        flag_type: String
      ).returns(EvaluationContext)
    end
    def build_context_with_before_hooks(flag_key:, default_value:, invocation_context:, options:, flag_type:)
      hook_context = build_hook_context(flag_key: flag_key, default_value: default_value,
                                        invocation_context: invocation_context, flag_type: flag_type)
      OpenFeatureSorbet::Hook::BeforeHook.call(hooks: build_hooks(options), context: hook_context,
                                               hints: {})
    end

    sig { params(options: T.nilable(EvaluationOptions)).returns(Hooks) }
    def build_hooks(options)
      Hooks.new(
        global: OpenFeatureSorbet.configuration.hooks,
        client: hooks,
        invocation: (options ? options.hooks : []),
        provider: provider.hooks
      )
    end

    sig do
      type_parameters(:U).params(
        flag_key: String,
        default_value: T.type_parameter(:U),
        invocation_context: T.nilable(EvaluationContext),
        flag_type: String
      ).returns(HookContext[T.type_parameter(:U)])
    end
    def build_hook_context(flag_key:, default_value:, invocation_context:, flag_type:)
      evaluation_context = build_context(invocation_context) || OpenFeatureSorbet::EvaluationContext.new
      HookContext.new(flag_key: flag_key, default_value: default_value,
                      evaluation_context: evaluation_context, flag_type: flag_type,
                      client_metadata: client_metadata, provider_metadata: provider.metadata)
    end

    sig { params(invocation_context: T.nilable(EvaluationContext)).returns(T.nilable(EvaluationContext)) }
    def build_context(invocation_context)
      EvaluationContextBuilder.new.call(
        global_context: OpenFeatureSorbet.configuration.evaluation_context,
        client_context: evaluation_context,
        invocation_context: invocation_context
      )
    end
  end
end
