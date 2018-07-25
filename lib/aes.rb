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
    crypto = Mcrypt.new(:rijndael_128, :cbc, @app_key, @app_secret, :zeros)
    enc = crypto.encrypt(str).to_hex_string(false)
  end

  def decrypt(str)
    str = str.to_byte_string
    crypto = Mcrypt.new(:rijndael_128, :cbc, @app_key, @app_secret, :zeros)
    crypto.decrypt(str)
  end 

  def weixin_decrypt_json(str)
    decrypted = JSON.parse(decrypt(str).strip.gsub(/\x00|\v/, ''))                                                                                                                                                                                       
    raise('Invalid Buffer') if decrypted["app_key"] != @app_key

    decrypted
  end                                                                                                                                      
end