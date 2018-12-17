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

    def initialize
      reset
    end

    # Resets the configuration to its defaults.
    def reset
      @secure_api_pass_phrase = ''
      @secure_api_salt = ''
      @secure_api_prefix = 'ssprefix-'
      @secure_api_suffix = '-sssuffix'
      nil
    end
  end
end
