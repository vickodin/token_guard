# frozen_string_literal: true

require "test_helper"

class TestTokenGuard < Minitest::Test
  include ActiveSupport::Testing::TimeHelpers

  def test_that_it_has_a_version_number
    refute_nil ::TokenGuard::VERSION
  end

  def test_sample_usage
    secret  = SecureRandom.hex(16)
    message = "Secure Message"
    purpose = "test"

    encrypted_message = TokenGuard.encrypt(message, purpose:, secret:)
    decrypted_message = TokenGuard.decrypt(encrypted_message, purpose:, secret:)

    assert decrypted_message == message
  end

  def test_not_expired
    secret  = SecureRandom.hex(16)
    message = "Secure Message with expiration"
    purpose = "test"

    encrypted_message = TokenGuard.encrypt(message, purpose:, secret:, expires_in: 3)
    decrypted_message = TokenGuard.decrypt(encrypted_message, purpose:, secret:)

    assert decrypted_message == message
  end

  def test_expired
    secret  = SecureRandom.hex(16)
    message = "Secure Message with expiration"
    purpose = "test"

    encrypted_message = TokenGuard.encrypt(message, purpose:, secret:, expires_in: 3.hours)

    travel 4.hours do
      decrypted_message = TokenGuard.decrypt(encrypted_message, purpose:, secret:)
      assert decrypted_message.nil?
    end
  end

  def test_rotation
    new_secret  = SecureRandom.hex(16)
    old_secret  = SecureRandom.hex(16)

    message = "Message for Rotation"
    purpose = "test"

    encrypted_message = TokenGuard.encrypt(message, purpose:, secret: old_secret)
    decrypted_message = TokenGuard.decrypt(encrypted_message, purpose:, secret: new_secret, old_secret:)

    assert decrypted_message == message
  end
end
