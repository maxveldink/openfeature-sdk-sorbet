# typed: true
# frozen_string_literal: true

module ConfigurationHelper
  def self.reset!
    OpenFeature.set_provider(OpenFeature::NoOpProvider.new)
  end
end
