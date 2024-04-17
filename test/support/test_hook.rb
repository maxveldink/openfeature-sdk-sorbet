# typed: false
# frozen_string_literal: true

require "open_feature_sorbet"

class TestHook < OpenFeatureSorbet::Hook::BeforeHook
  extend T::Sig

  # rubocop: disable Lint/MissingSuper
  def initialize(mock: nil)
    @mock = mock
  end
  # rubocop:enable Lint/MissingSuper

  def call(context:, hints:)
    mock ? mock.call([context, hints]) : OpenFeatureSorbet::EvaluationContext.new(targeting_key: nil)
  end

  attr_reader :mock
end
