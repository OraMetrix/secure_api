require 'secure_api/version'
require 'secure_api/configuration'
require 'secure_api/api_token'
require 'secure_api/access_token'

module SecureApi
  # def self.configuration=(config)
  #   @configuration = config
  # end

  # @return [SecureApi::Configuration]
  def self.configuration
    @configuration ||= Configuration.new
  end

  # @yield [SecureApi::Configuration]
  # @example
  #   SecureApi.configure do |config|
  #     config.secure_api_pass_phrase = '***'
  #     config.secure_api_salt = '***'
  #   end
  #
  def self.configure
    yield configuration
  end
end
