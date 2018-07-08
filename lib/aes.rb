require "openssl"                                                                                                                                                                                           
require "base64"                                                                                                                                                                                            
                                                                                                                                                                                                            
# include Base64
class Aes
  attr_accessor :app_key, :app_secret
  def initialize
    @app_key = Rails.application.credentials[Rails.env.to_sym][:app_key]
    @app_secret = Rails.application.credentials[Rails.env.to_sym][:app_secret][0,16] 
  end

  def encrypt(str)
    cipher = OpenSSL::Cipher::AES128.new(:CBC)                                                                                                                                                                  
    cipher.encrypt                                                                                                                                                                                              
    cipher.key = @app_key                                                                                                                                                                                            
    cipher.iv = @app_secret 
    cipher_text = cipher.update(str) + cipher.final
    # Base64.strict_encode64(cipher_text)
  end

  def decrypt(str)
    cipher = OpenSSL::Cipher::AES128.new(:CBC)     
    cipher.decrypt  
    cipher.key = @app_key                                                                                                                                                                                         
    cipher.iv = @app_secret                                                                                                                                                                                          
    decrypted_plain_text = cipher.update(str) + cipher.final
    # Base64.strict_encode64(decrypted_plain_text)
  end                                                                                                                                            
end