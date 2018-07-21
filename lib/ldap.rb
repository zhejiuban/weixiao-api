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
        Rails.logger = Logger.new(STDOUT)
        Rails.logger.error "LDAP 连接错误"
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

  def weixin_raw_data(username, password)
    result = auth(username, password)

    if result and result.count == 1
      card_number = result.first.uid.first
      name = result.first.cn.first.unpack('U*').map{ |i| "\\u" + i.to_s(16).rjust(4, '0') }.join
      if result.first.memberof.first == "cn=xs,ou=Groups,dc=whit,dc=ah,dc=cn"
        identity_type = "学生".unpack('U*').map{ |i| "\\u" + i.to_s(16).rjust(4, '0') }.join
      elsif result.first.memberof.first == "cn=jzg,ou=Groups,dc=whit,dc=ah,dc=cn"
        identity_type = "教职工".unpack('U*').map{ |i| "\\u" + i.to_s(16).rjust(4, '0') }.join
      end
      # raw_data = {
      #   "card_number" => result.first.uid.first,
      #   "name" => result.first.cn.first.unpack('U*').map{ |i| "\\u" + i.to_s(16).rjust(4, '0') }.join,
      #   "identity_type" => identity_type.unpack('U*').map{ |i| "\\u" + i.to_s(16).rjust(4, '0') }.join
      # }.as_json
      raw_data = "{\"card_number\":\"#{card_number}\",\"name\":\"#{name}\",\"identity_type\":\"#{identity_type}\"}"
    else
      result
    end
  end
end