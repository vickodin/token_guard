# frozen_string_literal: true

require_relative "token_guard/version"

# https://api.rubyonrails.org/v8.0.0/classes/ActiveSupport/MessageEncryptor.html
module TokenGuard
  # Standard Rails tools for message encryption/decryption (ActiveSupport::MessageEncryptor),
  #   packaged into a separate module. Works only with Rails (8+)
  #
  # Example:
  #   secret  = SecureRandom.hex(16) # 32 bytes
  #   message = "Secure Message"
  #   purpose = "email"
  #
  #   encrypted_message = TokenGuard.encrypt(message, purpose:, secret:)
  #
  # Later:
  #   TokenGuard.decrypt(encrypted_message, purpose:, secret:)
  # => "Secure Message"
  #
  # See tests and the top link for the details

  extend self

  def encrypt(message, purpose:, secret:, expires_in: nil)
    token = encryptor(secret).encrypt_and_sign(message, purpose:, expires_in:)
    encode(token)
  end

  def decrypt(url_token, purpose:, secret:, old_secret: nil)
    token = decode(url_token)
    decryptor = encryptor(secret, old_secret:)

    decryptor.decrypt_and_verify(token, purpose:)
  rescue ActiveSupport::MessageEncryptor::InvalidMessage, ArgumentError
    nil
  end

  private

  def encryptor(secret, old_secret: nil)
    encryptor = ActiveSupport::MessageEncryptor.new(secret)
    encryptor.rotate(old_secret) if old_secret.present?

    encryptor
  end

  def encode(data)
    Base64.urlsafe_encode64(data, padding: false)
  end

  def decode(data)
    Base64.urlsafe_decode64(data)
  end
end
