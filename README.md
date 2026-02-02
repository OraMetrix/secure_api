# SecureApi Gem

**Version:** 1.0.2  
**Authors:** DentsplySirona  
**License:** For DentsplySirona use only

## Description

SecureApi is a Ruby gem that creates and validates time-sensitive, URL-safe tokens for authorizing API access. It uses AES-256-GCM encryption to generate secure tokens with configurable expiration times, providing a robust authentication mechanism for API controllers in Rails applications.

## Key Features

- **Time-sensitive tokens**: Automatically expire after a configured duration
- **AES-256-GCM encryption**: Military-grade encryption with authentication tags
- **URL-safe encoding**: Tokens are Base64 URL-safe encoded for use in URLs and parameters
- **Rails integration**: Simple before_action filter for API authentication
- **Configurable security parameters**: Customizable cipher, key derivation, and token structure

## Configuration Parameters

The gem is configured through `SecureApi.configure` block, typically in a Rails initializer:

```ruby
# config/initializers/secure_api.rb
SecureApi.configure do |config|
  config.secure_api_pass_phrase = 'your-secret-passphrase'
  config.secure_api_salt = 'your-16-byte-salt'
  config.secure_api_cipher_name = 'AES-256-GCM'
  config.secure_api_key_iterations = 300_000
  config.secure_api_key_length = 32
  config.secure_api_auth_tag_length = 16
  config.secure_api_prefix = 'ssprefix-'
  config.secure_api_suffix = '-sssuffix'
end
```

### Required Parameters

- **`secure_api_pass_phrase`** (String)  
  The secret passphrase used for encryption key derivation. Keep this secure and unique per environment.

- **`secure_api_salt`** (String)  
  Must be exactly 16 bytes long. Used in key derivation function along with the passphrase.

### Optional Parameters (with defaults)

- **`secure_api_cipher_name`** (String)  
  *Default:* `'AES-256-GCM'`  
  The cipher algorithm used for encryption. AES-256-GCM provides both encryption and authentication.

- **`secure_api_key_iterations`** (Integer)  
  *Default:* `300_000`  
  Number of iterations for PBKDF2 key derivation. Higher values increase security but reduce performance.

- **`secure_api_key_length`** (Integer)  
  *Default:* `32`  
  Length of the derived encryption key in bytes (32 bytes = 256 bits for AES-256).

- **`secure_api_auth_tag_length`** (Integer)  
  *Default:* `16`  
  Length of the authentication tag in bytes for GCM mode (16 bytes recommended).

- **`secure_api_prefix`** (String)  
  *Default:* `'ssprefix-'`  
  Prefix added to generated tokens for easy identification.

- **`secure_api_suffix`** (String)  
  *Default:* `'-sssuffix'`  
  Suffix added to generated tokens for easy identification.

## Usage

### Protecting API Controllers

```ruby
class ApiController < ApplicationController
  include SecureApi::AccessToken
end
```

### Generating Tokens

```ruby
token = ApiToken.create
```

### Validating Tokens

```ruby
ApiToken.valid?(token) # returns true/false
```

### Sending Tokens with API Requests

```ruby
data = JSON.generate({
  method: method, 
  args: args, 
  access_token: ApiToken.create
})
response = RestClient.post(url, data,
  content_type: 'application/json',
  cookies: request.cookies)
```

## Security Considerations

- Keep `secure_api_pass_phrase` secret and unique per environment
- Ensure `secure_api_salt` is exactly 16 bytes and stored securely
- Use environment variables or encrypted credentials for sensitive configuration
- Tokens are time-sensitive and will expire after the configured duration
- The gem now generates a unique random initialization vector (IV) per encryption for enhanced security

## Dependencies

- Rails >= 7.2
- OpenSSL for cryptographic operations
- Base64 for URL-safe encoding
