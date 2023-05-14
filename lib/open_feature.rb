# typed: strict
# frozen_string_literal: true

require "sorbet-runtime"
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup

# Sorbet-aware implementation of the OpenFeature specification
module OpenFeature; end
