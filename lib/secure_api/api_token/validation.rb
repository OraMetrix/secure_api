require 'openssl'
require 'base64'

module ApiToken
  module Validation
    private

    def build_decrypter
      decrypter = OpenSSL::Cipher.new 'AES-256-CBC'
      decrypter.decrypt
      decrypter.key = key
      decrypter.iv = salt
      decrypter
    end

    def convert_string_to_hex(url_token)
      return nil unless url_token
      Base64.urlsafe_decode64(url_token)
    rescue ArgumentError
      nil
    end

    def decrypted_token(url_token)
      decrypter = build_decrypter
      hex_string = convert_string_to_hex(url_token)
      return false unless hex_string
      plain = decrypter.update hex_string
      plain << decrypter.final
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
