# require "openssl"
require 'mcrypt'                                                                                                                                                                                        
require "base64"                                                                                                                                                                                            
require 'hex_string'                                                                                                                                                                                                          
include Base64
class Aes
  attr_accessor :app_key, :app_secret
  def initialize
    @app_key = Rails.application.credentials[Rails.env.to_sym][:app_key]
    @app_secret = Rails.application.credentials[Rails.env.to_sym][:app_secret][0,16] 
  end

  def encrypt(str)
    # str = str + "\0" * (16 - str.length % 16)
    crypto = Mcrypt.new(:rijndael_128, :cbc, @app_key, @app_secret, :zeros)
    enc = crypto.encrypt(str).to_hex_string(false)
    # cipher = OpenSSL::Cipher::AES128.new(:CBC)
    # cipher.padding = 0                                                                                                                                                           
    # cipher.encrypt                                                                                                                                                                                
    # cipher.key = @app_key                                                                                                                                                                                            
    # cipher.iv = @app_secret 
    
    # cipher_text = cipher.update(str) + cipher.final
    # cipher_text = Base64.encode64(cipher_text)
    # cipher_text.to_hex_string(false)

    # AESCrypt.encrypt_data(str, @app_key, @app_secret, 'AES-128-CBC').to_hex_string(false)
  end

  def decrypt(str)
    str = str.to_byte_string
    crypto = Mcrypt.new(:rijndael_128, :cbc, @app_key, @app_secret, :zeros)
    crypto.decrypt(str)

    # cipher = OpenSSL::Cipher::AES128.new(:CBC)     
    # cipher.decrypt
    # cipher.padding = 0
    # cipher.key = @app_key                                                                                                                                                                                         
    # cipher.iv = @app_secret  
    # decrypted_plain_text = cipher.update(str.to_byte_string) << cipher.final 

    # decrypted_plain_text = cipher.update(hex_to_bin(str)) + cipher.final
    # Base64.strict_encode64(decrypted_plain_text)
  end 

  def weixin_decrypt_json(str)
    decrypted = JSON.parse(decrypt(str).strip.gsub(/\x00|\v/, ''))                                                                                                                                                                                       
    raise('Invalid Buffer') if decrypted["app_key"] != @app_key

    decrypted
  end

  # def bin_to_hex(s)
  #   s.unpack('H*').first
  # end
  
  # def hex_to_bin(s)
  #   s.scan(/../).map { |x| x.hex }.pack('c*')
  # end                                                                                                                                          
end