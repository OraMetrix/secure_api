require 'openssl'

module ApiToken
  module Defaults
    private
    # Reads pass_phrase from config (suresmile.yml)
    def pass_phrase
      ApplicationConfig[:secure_api_pass_phrase]
    end

    # Reads salt from config (suresmile.yml)
    # Salt has to be 16 bytes long
    # @return [String]
    def salt
      ApplicationConfig[:secure_api_salt]
    end

    # Generates a key
    # @return [String]
    def key
      OpenSSL::PKCS5.pbkdf2_hmac_sha1(pass_phrase, salt, 20000, 32)
    end

    # 60 * 10 => ten minutes slop between server times
    # @return [Integer]
    def time_tolerance_seconds
      600
    end

    # @return [String]
    def prefix
      'ssprefix-'
    end

    # @return [String]
    def suffix
      '-sssuffix'
    end

    # @return [Integer]
    def timestamp
      Time.now.utc.to_i
    end
  end
end
