# typed: true
# frozen_string_literal: true

require "open_feature_sorbet"

class TestProvider < OpenFeatureSorbet::Provider
  attr_reader :counter

  def initialize(raising: false, erroring: false, number_value: 2.4, counter: nil)
    @raising = raising
    @erroring = erroring
    @number_value = number_value
    @counter = counter
    super(OpenFeatureSorbet::ProviderStatus::Ready)
  end

  def metadata
    OpenFeatureSorbet::ProviderMetadata.new(name: "Test Provider")
  end

  def hooks
    [TestHook.new]
  end

  def init(context:) # rubocop:disable Lint/UnusedMethodArgument
    @status = OpenFeatureSorbet::ProviderStatus::Error if @erroring || @raising
    @counter.init_calls += 1
  end

  def shutdown
    @counter.shutdown_calls += 1
  end

  def resolve_boolean_value(**_)
    raise TypeError if @raising

    build_details(true)
  end

  def resolve_string_value(**_)
    raise TypeError if @raising

    build_details("testing")
  end

  def resolve_number_value(**_)
    raise TypeError if @raising

    build_details(@number_value)
  end

  def resolve_structure_value(**_)
    raise TypeError if @raising

    build_details({ "testing" => "123" })
  end

  private

  def build_details(value)
    if @erroring
      OpenFeatureSorbet::ResolutionDetails.new(value: value, error_code: OpenFeatureSorbet::ErrorCode::General,
                                               reason: "ERROR")
    else
      OpenFeatureSorbet::ResolutionDetails.new(value: value, reason: "STATIC")
    end
  end
end
