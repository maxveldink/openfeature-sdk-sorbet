# typed: strict
# frozen_string_literal: true

module OpenFeature
  # Used to pull from multiple providers.
  # Order of the providers given to initialize matters.
  # The providers will be evaluated in that order and the first
  # non-error result will be used. If all sources return an error
  # then the default value is used.
  class MultipleSourceProvider < Provider
    extend T::Sig

    sig { params(providers: T::Array[Provider]).void }
    def initialize(providers:)
      @providers = providers
      super(ProviderStatus::NotReady)
    end

    sig { override.returns(ProviderMetadata) }
    def metadata
      ProviderMetadata.new(name: "Multiple Sources: #{providers.map { |provider| provider.metadata.name }.join(", ")}")
    end

    sig { override.returns(T::Array[Hook]) }
    def hooks
      providers.flat_map(&:hooks)
    end

    sig { override.params(context: EvaluationContext).void }
    def init(context:)
      providers.each { |provider| provider.init(context: context) }
      @status = if providers.all? { |provider| provider.status == ProviderStatus::Ready }
                  ProviderStatus::Ready
                else
                  ProviderStatus::Error
                end
    rescue StandardError
      @status = ProviderStatus::Error
    end

    sig { override.void }
    def shutdown
      providers.each(&:shutdown)
    end

    sig do
      override
        .params(
          flag_key: String,
          default_value: T::Boolean,
          context: T.nilable(EvaluationContext)
        )
        .returns(ResolutionDetails[T::Boolean])
    end
    def resolve_boolean_value(flag_key:, default_value:, context: nil)
      resolve_from_sources(default_value: default_value) do |provider|
        provider.resolve_boolean_value(flag_key: flag_key, default_value: default_value, context: context)
      end
    end

    sig do
      override
        .params(
          flag_key: String,
          default_value: Numeric,
          context: T.nilable(EvaluationContext)
        )
        .returns(ResolutionDetails[Numeric])
    end
    def resolve_number_value(flag_key:, default_value:, context: nil)
      resolve_from_sources(default_value: default_value) do |provider|
        provider.resolve_number_value(flag_key: flag_key, default_value: default_value, context: context)
      end
    end

    sig do
      override
        .params(
          flag_key: String,
          default_value: Structure,
          context: T.nilable(EvaluationContext)
        )
        .returns(ResolutionDetails[Structure])
    end
    def resolve_structure_value(flag_key:, default_value:, context: nil)
      resolve_from_sources(default_value: default_value) do |provider|
        provider.resolve_structure_value(flag_key: flag_key, default_value: default_value, context: context)
      end
    end

    sig do
      override
        .params(
          flag_key: String,
          default_value: String,
          context: T.nilable(EvaluationContext)
        )
        .returns(ResolutionDetails[String])
    end
    def resolve_string_value(flag_key:, default_value:, context: nil)
      resolve_from_sources(default_value: default_value) do |provider|
        provider.resolve_string_value(flag_key: flag_key, default_value: default_value, context: context)
      end
    end

    private

    sig { returns(T::Array[Provider]) }
    attr_reader :providers

    # rubocop:disable Metrics/MethodLength
    sig do
      type_parameters(:U)
        .params(
          default_value: T.type_parameter(:U),
          blk: T.proc.params(arg0: Provider).returns(ResolutionDetails[T.type_parameter(:U)])
        )
        .returns(ResolutionDetails[T.type_parameter(:U)])
    end
    def resolve_from_sources(default_value:, &blk)
      successful_details = providers.each do |provider|
        details = yield(provider)

        break details if details.error_code.nil?
      rescue StandardError
        next
      end

      if successful_details.is_a?(ResolutionDetails)
        successful_details
      else
        ResolutionDetails.new(value: default_value, error_code: ErrorCode::General, reason: "ERROR")
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
