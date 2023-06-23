# typed: true
# frozen_string_literal: true

require "test_helper"

class OpenFeatureTest < Minitest::Test
  def teardown
    OpenFeature.configuration.reset!
  end

  def test_returns_provider_metadata
    assert_equal(OpenFeature::ProviderMetadata.new(name: "No Op Provider"), OpenFeature.provider_metadata)
  end

  def test_provider_can_be_set
    OpenFeature.set_provider(TestProvider.new)

    assert_equal("Test Provider", OpenFeature.provider_metadata.name)
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
