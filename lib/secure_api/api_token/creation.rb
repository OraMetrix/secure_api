require 'openssl'
require 'base64'

# Requires defaults to work

module ApiToken
  module Creation
    private

    # create new token
    def url_encrypted_token
      Base64.urlsafe_encode64(encrypted_hex)
    end

    def encrypted_hex
      encrypter = OpenSSL::Cipher.new(cipher_name)
      encrypter.encrypt
      encrypter.key = key
      # Generate random IV for each encryption (IV doesn't need to be secret)
      iv = encrypter.random_iv
      encrypter.iv = iv
      
      encrypted = encrypter.update new_token
      encrypted << encrypter.final
      
      # For GCM mode, append the authentication tag
      if encrypter.authenticated?
        encrypted << encrypter.auth_tag
      end
      
      # Prepend IV to the encrypted data (IV is not secret, only key is)
      iv + encrypted
    end

    def new_token
      "#{prefix}#{timestamp}#{suffix}"
    end
  end
end
