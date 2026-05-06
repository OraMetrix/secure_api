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
      nil
    end
  end
end
