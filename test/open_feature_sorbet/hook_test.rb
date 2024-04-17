# typed: false
# frozen_string_literal: true

class HookTest < Minitest::Test
  # See Requirement 4.3.4
  def test_single_before_hook_is_called_and_updates_evaluation_context
    hook = TestHook.new mock: Minitest::Mock.new
    hook_context = build_test_hook_context(fields: { "k1" => "v1" })
    hook_return_context = OpenFeatureSorbet::EvaluationContext.new(targeting_key: "foo",
                                                                   fields:
                                                               { "k2" => "v2" })
    hook.mock.expect(:call, hook_return_context, [[hook_context, {}]])
    result = OpenFeatureSorbet::Hook::BeforeHook.call(hooks: OpenFeatureSorbet::Hooks.new(invocation: [hook]),
                                                      context: hook_context, hints: {})

    assert_equal(result, hook_context.evaluation_context.merge(hook_return_context))
  end

  # See https://openfeature.dev/specification/sections/hooks#42-hook-hints
  # TODO: Answer what hook hints are for?
  def test_single_hook_is_called_with_hook_hints
    hook = TestHook.new mock: Minitest::Mock.new
    hook_context = build_test_hook_context
    hook_return_context = OpenFeatureSorbet::EvaluationContext.new(targeting_key: nil)
    hints = { "xhint" => "yvalue" }
    hook.mock.expect(:call, hook_return_context, [[hook_context, hints]])
    OpenFeatureSorbet::Hook::BeforeHook.call(hooks: OpenFeatureSorbet::Hooks.new(invocation: [hook]), context: hook_context,
                                             hints: hints)
    hook.mock.verify
  end

  # See requirement 4.3.3, 4.3.4
  #
  # rubocop: disable Metrics/AbcSize
  def test_multiple_before_hook_works
    hooks = OpenFeatureSorbet::Hooks.new(invocation: (0..5).map { |_| TestHook.new mock: Minitest::Mock.new })

    initial_hook_context = build_test_hook_context(targeting_key: "-1")

    hooks.before.each_with_index.map do |hook, index|
      last_context = build_test_hook_context(targeting_key: (index - 1).to_s)
      hook.mock.expect(:call, OpenFeatureSorbet::EvaluationContext.new(targeting_key: index.to_s), [[last_context, {}]])
    end

    result = OpenFeatureSorbet::Hook::BeforeHook.call(hooks: hooks, context: initial_hook_context, hints: {})

    assert_equal(result, OpenFeatureSorbet::EvaluationContext.new(targeting_key: (hooks.before.length - 1).to_s))
  end
  # rubocop: enable Metrics/AbcSize

  private

  def build_test_hook_context(targeting_key: nil, fields: {})
    OpenFeatureSorbet::HookContext.new(flag_key: "test",
                                       flag_type: "String",
                                       evaluation_context: OpenFeatureSorbet::EvaluationContext.new(
                                         targeting_key: targeting_key,
                                         fields: fields
                                       ),
                                       default_value: "",
                                       client_metadata: OpenFeatureSorbet::ClientMetadata.new,
                                       provider_metadata: OpenFeatureSorbet::ProviderMetadata.new(name: "test0"))
  end
end
