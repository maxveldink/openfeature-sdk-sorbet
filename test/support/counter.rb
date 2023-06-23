# typed: true
# frozen_string_literal: true

require "singleton"

class Counter
  include Singleton

  attr_accessor :shutdown_calls

  def intialize(shutdown_calls = 0)
    @shutdown_calls = shutdown_calls
  end

  def reset!
    @shutdown_calls = 0
  end
end
