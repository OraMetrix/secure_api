require 'openssl'
require "base64"

# Requires defaults to work

module ApiToken
  module Creation
    private
    # create new token
      def url_encrypted_token
        Base64.urlsafe_encode64(encrypted_hex)
      end

      def encrypted_hex
        encrypter = build_encrypter
        encrypted = encrypter.update new_token
        encrypted << encrypter.final
      end

      def build_encrypter
        encrypter = OpenSSL::Cipher.new 'AES-256-CBC'
        encrypter.encrypt
        encrypter.key = key
        encrypter.iv = salt
        encrypter
      end

      def new_token
        "#{prefix}#{timestamp}#{suffix}"
      end
  end
end