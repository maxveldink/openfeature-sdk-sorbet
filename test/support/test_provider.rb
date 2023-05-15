# typed: true
# frozen_string_literal: true

require "open_feature"

class TestProvider
  include OpenFeature::Provider

  def metadata
    OpenFeature::ProviderMetadata.new(name: "Test Provider")
  end

  def hooks
    []
  end

  def resolve_boolean_value(**_)
    OpenFeature::ResolutionDetails.new(value: true, reason: "STATIC")
  end

  def resolve_string_value(**_)
    OpenFeature::ResolutionDetails.new(value: "testing", reason: "STATIC")
  end

  def resolve_number_value(**_)
    OpenFeature::ResolutionDetails.new(value: 2.4, reason: "STATIC")
  end

  def resolve_structure_value(**_)
    OpenFeature::ResolutionDetails.new(value: { "testing" => "123" }, reason: "STATIC")
  end
end
