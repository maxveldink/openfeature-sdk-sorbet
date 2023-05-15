# typed: true
# frozen_string_literal: true

class ClientTest < Minitest::Test
  def setup
    @client = OpenFeature::Client.new(name: "testing")
  end

  def test_is_initialized_properly
    assert_equal("testing", @client.client_metadata.name)
    assert_empty(@client.hooks)
  end

  def test_hooks_can_be_added
    @client.add_hooks(OpenFeature::Hook.new)
    @client.add_hooks([OpenFeature::Hook.new, OpenFeature::Hook.new])

    assert_equal(3, @client.hooks.size)
  end
end
