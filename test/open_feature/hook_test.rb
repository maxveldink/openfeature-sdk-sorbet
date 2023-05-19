# typed: true
# frozen_string_literal: true

require_relative "../support/test_provider"
require_relative "../support/test_hook"

class HookTest < Minitest::Test
  # See Requirement 4.3.4
  def test_single_before_hook_is_called_and_updates_evaluation_context
    hook = TestHook.new mock: Minitest::Mock.new
    hook_context = build_test_hook_context(fields: { "k1" => "v1" })
    hook_return_context = OpenFeature::EvaluationContext.new(targeting_key: "foo",
                                                             fields:
                                                               { "k2" => "v2" })
    hook.mock.expect(:call, hook_return_context, [[hook_context, {}]])
    result = OpenFeature::Hook::BeforeHook.call(hooks: [hook], context: hook_context, hints: {})

    assert_equal(result, hook_context.evaluation_context.merge(hook_return_context))
  end

  # See https://openfeature.dev/specification/sections/hooks#42-hook-hints
  # TODO: Answer what hook hints are for?
  def test_single_hook_is_called_with_hook_hints
    hook = TestHook.new mock: Minitest::Mock.new
    hook_context = build_test_hook_context
    hook_return_context = OpenFeature::EvaluationContext.new(targeting_key: nil)
    hints = { "xhint" => "yvalue" }
    hook.mock.expect(:call, hook_return_context, [[hook_context, hints]])
    OpenFeature::Hook::BeforeHook.call(hooks: [hook], context: hook_context, hints: hints)
    hook.mock.verify
  end

  # See requirement 4.3.3, 4.3.4
  #
  # rubocop: disable Metrics/AbcSize
  def test_multiple_before_hook_works
    hooks = (0..5).map { |_| TestHook.new mock: Minitest::Mock.new }

    initial_hook_context = build_test_hook_context(targeting_key: "-1")

    hooks.each_with_index.map do |hook, index|
      last_context = build_test_hook_context(targeting_key: (index - 1).to_s)
      hook.mock.expect(:call, OpenFeature::EvaluationContext.new(targeting_key: index.to_s), [[last_context, {}]])
    end

    result = OpenFeature::Hook::BeforeHook.call(hooks: hooks, context: initial_hook_context, hints: {})

    assert_equal(result, OpenFeature::EvaluationContext.new(targeting_key: (hooks.length - 1).to_s))
  end
  # rubocop: enable Metrics/AbcSize

  private

  def build_test_hook_context(targeting_key: nil, fields: {})
    OpenFeature::HookContext.new(flag_key: "test",
                                 flag_type: "String",
                                 evaluation_context: OpenFeature::EvaluationContext.new(
                                   targeting_key: targeting_key,
                                   fields: fields
                                 ),
                                 default_value: "",
                                 client_metadata: OpenFeature::ClientMetadata.new,
                                 provider_metadata: OpenFeature::ProviderMetadata.new(name: "test0"))
  end
end
