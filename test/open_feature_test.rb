# typed: true
# frozen_string_literal: true

require "test_helper"

class OpenFeatureTest < Minitest::Test
  def setup
    Counter.instance.intialize
  end

  def teardown
    OpenFeature.configuration.reset!
    Counter.instance.reset!
  end

  def test_returns_provider_metadata
    assert_equal(OpenFeature::ProviderMetadata.new(name: "No Op Provider"), OpenFeature.provider_metadata)
  end

  def test_provider_can_be_set
    OpenFeature.set_provider(TestProvider.new(counter: Counter.instance))

    assert_equal("Test Provider", OpenFeature.provider_metadata.name)
    assert_equal(1, Counter.instance.init_calls)
  end

  def test_set_provider_shuts_down_current_provider_and_initializes_new_one
    OpenFeature.set_provider(TestProvider.new(counter: Counter.instance))
    OpenFeature.set_provider(TestProvider.new(counter: Counter.instance))

    assert_equal(2, Counter.instance.init_calls)
    assert_equal(1, Counter.instance.shutdown_calls)
  end

  def test_shutdown_calls_provider_shutdown
    OpenFeature.set_provider(TestProvider.new(counter: Counter.instance))

    OpenFeature.shutdown

    assert_equal(1, Counter.instance.shutdown_calls)
  end

  def test_evaluation_context_can_be_set
    OpenFeature.set_evaluation_context(OpenFeature::EvaluationContext.new)

    refute_nil(OpenFeature.configuration.evaluation_context)
  end

  def test_hooks_can_be_added
    OpenFeature.add_hooks(TestHook.new)
    OpenFeature.add_hooks([TestHook.new, TestHook.new])

    assert_equal(3, OpenFeature::Configuration.instance.hooks.size)
  end

  def test_can_create_client_without_arguments
    client = OpenFeature.create_client

    assert_nil(client.client_metadata.name)
    assert_nil(client.evaluation_context)
    assert_empty(client.hooks)
  end

  def test_can_create_client_with_arguments
    client = OpenFeature.create_client(
      name: "test_client",
      evaluation_context: OpenFeature::EvaluationContext.new,
      hooks: TestHook.new
    )

    assert_equal("test_client", client.client_metadata.name)
    refute_nil(client.evaluation_context)
    refute_empty(client.hooks)
  end
end
