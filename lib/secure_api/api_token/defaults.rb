require 'openssl'

module ApiToken
  # Helper to access the configuration.
  module Defaults
    private

    def pass_phrase
      SecureApi.configuration.secure_api_pass_phrase
    end

    # Salt for key derivation (minimum 8 bytes recommended)
    # @return [String]
    def salt
      SecureApi.configuration.secure_api_salt
    end

    # Generates a key
    # @return [String]
    def key
      OpenSSL::PKCS5.pbkdf2_hmac(pass_phrase, salt, key_iterations, key_length, 'sha512')
    end

    # 60 * 10 => ten minutes slop between server times
    # @return [Integer]
    def time_tolerance_seconds
      600
    end

    # @return [String]
    def prefix
      SecureApi.configuration.secure_api_prefix
    end

    # @return [String]
    def suffix
      SecureApi.configuration.secure_api_suffix
    end

    # @return [Integer]
    def timestamp
      Time.now.utc.to_i
    end

    # @return [String]
    def cipher_name
      SecureApi.configuration.secure_api_cipher_name
    end

    # @return [Integer]
    def key_iterations
      SecureApi.configuration.secure_api_key_iterations
    end

    # @return [Integer]
    def key_length
      SecureApi.configuration.secure_api_key_length
    end

    # @return [Integer]
    def auth_tag_length
      SecureApi.configuration.secure_api_auth_tag_length
    end

    # Enables legacy token creation format (CBC + static IV from salt).
    # @return [Boolean]
    def legacy_encryption_enabled?
      SecureApi.configuration.secure_api_enable_legacy_encryption
    end

    # Legacy cipher for backward-compatible decryption/encryption.
    # @return [String]
    def legacy_cipher_name
      SecureApi.configuration.secure_api_legacy_cipher_name
    end

    # PBKDF2 iterations used by legacy SHA1 key derivation.
    # @return [Integer]
    def legacy_key_iterations
      SecureApi.configuration.secure_api_legacy_key_iterations
    end

    # Legacy key derivation used by pre-GCM tokens.
    # @return [String]
    def legacy_key
      OpenSSL::PKCS5.pbkdf2_hmac_sha1(pass_phrase, salt, legacy_key_iterations, key_length)
    end
  end
end
