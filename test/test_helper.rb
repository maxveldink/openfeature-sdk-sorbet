# typed: strict
# frozen_string_literal: true

require "minitest/autorun"
require "debug"
require "open_feature_sorbet"

Dir["#{__dir__}/support/**/*.rb"].each { |file| require file }
