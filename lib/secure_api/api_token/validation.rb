require 'openssl'
require 'base64'

module ApiToken
  module Validation
    private

    def decode_url_token(url_token)
      return nil unless url_token
      Base64.urlsafe_decode64(url_token)
    rescue ArgumentError
      nil
    end

    def decrypted_token(url_token)
      hex_string = decode_url_token(url_token)
      return nil unless hex_string
      
      # Extract IV from the beginning of the data
      iv_length = OpenSSL::Cipher.new(cipher_name).iv_len
      return nil if hex_string.bytesize < iv_length
      
      iv = hex_string[0...iv_length]
      remaining_data = hex_string[iv_length..-1]
      
      # Build decrypter with extracted IV
      decrypter = OpenSSL::Cipher.new(cipher_name)
      decrypter.decrypt
      decrypter.key = key
      decrypter.iv = iv
      
      # For GCM mode, extract and set the authentication tag
      if decrypter.authenticated?
        return nil if remaining_data.bytesize < auth_tag_length
        ciphertext = remaining_data[0...-auth_tag_length]
        auth_tag = remaining_data[-auth_tag_length..-1]
        decrypter.auth_tag = auth_tag
      else
        ciphertext = remaining_data
      end
      
      plain = decrypter.update ciphertext
      plain << decrypter.final
      plain
    rescue OpenSSL::Cipher::CipherError
      nil
    end

    def within_time_tolerance(clear_token)
      clear_token[/#{prefix}([0-9]+)#{suffix}/]
      token_time = $1 || 0
      elapsed_time = timestamp.to_i - token_time.to_i
      elapsed_time < time_tolerance_seconds
    end
  end
end
