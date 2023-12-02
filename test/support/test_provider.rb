# typed: true
# frozen_string_literal: true

require "open_feature"

class TestProvider < OpenFeature::Provider
  attr_reader :counter

  def initialize(raising: false, erroring: false, number_value: 2.4, counter: nil)
    @raising = raising
    @erroring = erroring
    @number_value = number_value
    @counter = counter
    super(OpenFeature::ProviderStatus::Ready)
  end

  def metadata
    OpenFeature::ProviderMetadata.new(name: "Test Provider")
  end

  def hooks
    [TestHook.new]
  end

  def init(context:) # rubocop:disable Lint/UnusedMethodArgument
    @status = OpenFeature::ProviderStatus::Error if @erroring || @raising
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
      OpenFeature::ResolutionDetails.new(value:, error_code: OpenFeature::ErrorCode::General, reason: "ERROR")
    else
      OpenFeature::ResolutionDetails.new(value:, reason: "STATIC")
    end
  end
end
