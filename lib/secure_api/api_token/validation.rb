require 'openssl'
require 'base64'

module ApiToken
  module Validation
    private

    # Decodes a URL-safe Base64 token payload.
    # @param url_token [String, nil] URL-safe Base64 encoded token value
    # @return [String, nil] Raw decoded bytes or nil when input is invalid
    def decode_url_token(url_token)
      return nil unless url_token
      Base64.urlsafe_decode64(url_token)
    rescue ArgumentError
      nil
    end

    # Decrypts a token with current format first and legacy format as fallback.
    # @param url_token [String, nil] URL-safe Base64 encoded token value
    # @return [String, nil] Decrypted token payload or nil when decryption fails
    def decrypted_token(url_token)
      hex_string = decode_url_token(url_token)
      return nil unless hex_string

      decrypted = decrypt_current(hex_string)
      return decrypted if decrypted

      decrypt_legacy(hex_string)
    end

    # Decrypts a payload using the current format where IV is prepended.
    # @param hex_string [String] Raw decoded token payload bytes
    # @return [String, nil] Decrypted plaintext or nil when decryption fails
    def decrypt_current(hex_string)
      iv_length = OpenSSL::Cipher.new(cipher_name).iv_len
      return nil if hex_string.bytesize < iv_length

      iv = hex_string[0...iv_length]
      remaining_data = hex_string[iv_length..-1]

      decrypter = OpenSSL::Cipher.new(cipher_name)
      decrypter.decrypt
      decrypter.key = key
      decrypter.iv = iv

      if decrypter.authenticated?
        return nil if remaining_data.bytesize < auth_tag_length

        auth_tag = remaining_data[-auth_tag_length..-1]
        decrypter.auth_tag = auth_tag
        ciphertext = remaining_data[0...-auth_tag_length]
      else
        ciphertext = remaining_data
      end

      plain = decrypter.update ciphertext
      plain << decrypter.final
      plain
    rescue OpenSSL::Cipher::CipherError
      nil
    end

    # Decrypts a payload using the legacy format with static IV from salt.
    # @param hex_string [String] Raw decoded token payload bytes
    # @return [String, nil] Decrypted plaintext or nil when decryption fails
    def decrypt_legacy(hex_string)
      decrypter = OpenSSL::Cipher.new(legacy_cipher_name)
      return nil unless salt.bytesize == decrypter.iv_len

      decrypter.decrypt
      decrypter.key = legacy_key
      decrypter.iv = salt

      plain = decrypter.update hex_string
      plain << decrypter.final
      plain
    rescue OpenSSL::Cipher::CipherError, ArgumentError
      nil
    end

    # Verifies token timestamp is within allowed tolerance.
    # @param clear_token [String] Decrypted token payload
    # @return [Boolean] True when token age is within tolerance
    def within_time_tolerance(clear_token)
      clear_token[/#{prefix}([0-9]+)#{suffix}/]
      token_time = $1 || 0
      elapsed_time = timestamp.to_i - token_time.to_i
      elapsed_time.abs < time_tolerance_seconds
    end
  end
end
