# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
# require "active_support"
# require "active_support/core_ext/time"
require "active_support/all"
# require "activeSupport::Testing::TimeHelpers
require "active_support/testing/time_helpers"
require "securerandom"
require "token_guard"

require "minitest/autorun"
