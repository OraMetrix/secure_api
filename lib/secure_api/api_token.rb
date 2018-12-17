require 'openssl'
require 'base64'

require 'secure_api/api_token/defaults'
require 'secure_api/api_token/creation'
require 'secure_api/api_token/validation'

module ApiToken
  extend ApiToken::Defaults
  extend ApiToken::Creation
  extend ApiToken::Validation

  def self.create
    url_encrypted_token
  end

  def self.valid?(token)
    clear_token = decrypted_token(token)
    clear_token && within_time_tolerance(clear_token)
  end
end
