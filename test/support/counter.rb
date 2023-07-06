# typed: true
# frozen_string_literal: true

require "singleton"

class Counter
  include Singleton

  attr_accessor :init_calls, :shutdown_calls

  def intialize(init_calls = 0, shutdown_calls = 0)
    @init_calls = init_calls
    @shutdown_calls = shutdown_calls
  end

  def reset!
    @init_calls = 0
    @shutdown_calls = 0
  end
end
