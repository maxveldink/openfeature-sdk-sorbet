# typed: true
# frozen_string_literal: true

require "test_helper"

class OpenFeatureSorbetTest < Minitest::Test
  def setup
    Counter.instance.intialize
  end

  def teardown
    OpenFeatureSorbet.configuration.reset!
    Counter.instance.reset!
  end

  def test_returns_provider_metadata
    assert_equal(OpenFeatureSorbet::ProviderMetadata.new(name: "No Op Provider"), OpenFeatureSorbet.provider_metadata)
  end

  def test_provider_can_be_set
    OpenFeatureSorbet.set_provider(TestProvider.new(counter: Counter.instance))

    assert_equal("Test Provider", OpenFeatureSorbet.provider_metadata.name)
    assert_equal(1, Counter.instance.init_calls)
  end

  def test_set_provider_shuts_down_current_provider_and_initializes_new_one
    OpenFeatureSorbet.set_provider(TestProvider.new(counter: Counter.instance))
    OpenFeatureSorbet.set_provider(TestProvider.new(counter: Counter.instance))

    assert_equal(2, Counter.instance.init_calls)
    assert_equal(1, Counter.instance.shutdown_calls)
  end

  def test_shutdown_calls_provider_shutdown
    OpenFeatureSorbet.set_provider(TestProvider.new(counter: Counter.instance))

    OpenFeatureSorbet.shutdown

    assert_equal(1, Counter.instance.shutdown_calls)
  end

  def test_evaluation_context_can_be_set
    OpenFeatureSorbet.set_evaluation_context(OpenFeatureSorbet::EvaluationContext.new)

    refute_nil(OpenFeatureSorbet.configuration.evaluation_context)
  end

  def test_hooks_can_be_added
    OpenFeatureSorbet.add_hooks(TestHook.new)
    OpenFeatureSorbet.add_hooks([TestHook.new, TestHook.new])

    assert_equal(3, OpenFeatureSorbet::Configuration.instance.hooks.size)
  end

  def test_can_create_client_without_arguments
    client = OpenFeatureSorbet.create_client

    assert_nil(client.client_metadata.name)
    assert_nil(client.evaluation_context)
    assert_empty(client.hooks)
  end

  def test_can_create_client_with_arguments
    client = OpenFeatureSorbet.create_client(
      name: "test_client",
      evaluation_context: OpenFeatureSorbet::EvaluationContext.new,
      hooks: TestHook.new
    )

    assert_equal("test_client", client.client_metadata.name)
    refute_nil(client.evaluation_context)
    refute_empty(client.hooks)
  end
end
