require 'net/ldap'
class Ldap
  def initialize()
    ldap_configs = Rails.application.credentials[Rails.env.to_sym][:ldap]
    ldap_configs = ldap_configs.is_a?(Hash) ? [ldap_configs] : ldap_configs
    ldap_configs.each do |ldap_config|
      begin
        @ldap = Net::LDAP.new
        @ldap.host = ldap_config[:host]
        @ldap.port = ldap_config[:port]
        @ldap.auth ldap_config[:admin_user], ldap_config[:admin_password]
        break if @ldap.bind
      rescue
        logger.error "LDAP 连接错误"
      end
    end
  end

  def auth(username,password)
    result = @ldap.bind_as(
      :base => "dc=whit,dc=ah,dc=cn",
      :filter => "(uid=#{username})",
      :password => password
      )
  end
end