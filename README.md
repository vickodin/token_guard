# TokenGuard

Standard Rails tools for message encryption/decryption (ActiveSupport::MessageEncryptor), packaged into a separate module.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add token_guard
```

## Usage

### Basic

```ruby
secret  = SecureRandom.hex(16) # 32 bytes
message = "Secure Message"
purpose = "email"

encrypted_message = TokenGuard.encrypt(message, purpose:, secret:)

# Later:
decrypted_message = TokenGuard.decrypt(encrypted_message, purpose:, secret:)

# Now `decrypted_message` equals `message`
```

### With expiration

```ruby
encrypted_message = TokenGuard.encrypt(message, purpose:, secret:, expires_in: 4.hours)
```

### With secret rotation

```ruby
new_secret  = SecureRandom.hex(16)
old_secret  = SecureRandom.hex(16)

message = "Message"
purpose = "confirmation"

encrypted_message = TokenGuard.encrypt(message, purpose:, secret: old_secret)
decrypted_message = TokenGuard.decrypt(encrypted_message, purpose:, secret: new_secret, old_secret:)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vickodin/token_guard. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/vickodin/token_guard/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
