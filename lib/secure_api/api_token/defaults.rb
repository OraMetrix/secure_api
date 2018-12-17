require 'openssl'

module ApiToken
  # Helper to access the configuration.
  module Defaults
    private

    def pass_phrase
      SecureApi.configuration.secure_api_pass_phrase
    end

    # Salt has to be 16 bytes long
    # @return [String]
    def salt
      SecureApi.configuration.secure_api_salt
    end

    # Generates a key
    # @return [String]
    def key
      OpenSSL::PKCS5.pbkdf2_hmac_sha1(pass_phrase, salt, 20_000, 32)
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
  end
end
