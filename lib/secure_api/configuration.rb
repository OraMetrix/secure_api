module SecureApi
  class Configuration
    # The very secret secure pass phrase.
    # @return [String]
    attr_accessor :secure_api_pass_phrase

    # Salt has to be 16 bytes long
    # @return [String]
    attr_accessor :secure_api_salt

    attr_accessor :secure_api_prefix
    attr_accessor :secure_api_suffix

    # @return [String]
    attr_accessor :secure_api_cipher_name

    # @return [Integer]
    attr_accessor :secure_api_key_iterations

    # return [Integer]
    attr_accessor :secure_api_key_length

    # return [Integer]
    attr_accessor :secure_api_auth_tag_length

    # Enable legacy token encryption (AES-256-CBC + PBKDF2-HMAC-SHA1)
    # @return [Boolean]
    attr_accessor :secure_api_enable_legacy_encryption

    # Legacy cipher algorithm used before migration to GCM
    # @return [String]
    attr_accessor :secure_api_legacy_cipher_name

    # PBKDF2 iteration count used for legacy SHA1 key derivation
    # @return [Integer]
    attr_accessor :secure_api_legacy_key_iterations

    def initialize
      reset
    end

    # Resets the configuration to its defaults.
    def reset
      @secure_api_pass_phrase = ''
      @secure_api_salt = ''
      @secure_api_prefix = 'ssprefix-'
      @secure_api_suffix = '-sssuffix'
      @secure_api_cipher_name = 'AES-256-GCM'
      @secure_api_key_iterations = 300_000
      @secure_api_key_length = 32
      @secure_api_auth_tag_length = 16
      @secure_api_enable_legacy_encryption = false
      @secure_api_legacy_cipher_name = 'AES-256-CBC'
      @secure_api_legacy_key_iterations = 20_000
      nil
    end
  end
end
