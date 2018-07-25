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

  def auth_with_database(username,password)
    result = auth(username, password)
    if result and result.count == 1
      if result.first.memberof.first == "cn=xs,ou=Groups,dc=whit,dc=ah,dc=cn"
        user = Student.find_by_card_number username
      elsif result.first.memberof.first == "cn=jzg,ou=Groups,dc=whit,dc=ah,dc=cn"
        user = Teacher.find_by_card_number username
      else
        user = Alumnu.find_by_card_number username
      end
      raw_data = "{\"card_number\":\"#{user.card_number}\",\"name\":\"#{user.name}\",\"gender\":\"#{user.gender}\",\"grade\":\"#{user.grade}\",\"college\":\"#{user.college}\",\"profession\":\"#{user.profession}\",\"class\":\"#{user.bj}\",\"identity_type\":\"#{user.identity_type}\",\"identity_title\":\"#{user.identity_title}\",\"id_card\":\"#{user.id_card}\",\"telephone\":\"#{user.telephone}\",\"organization\":\"#{user.organization}\",\"physical_card_number\":\"#{user.physical_card_number}\"}"
    else
      result
    end
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
      raw_data = "{\"card_number\":\"#{card_number}\",\"name\":\"#{name}\",\"identity_type\":\"#{identity_type}\"}"
    else
      result
    end
  end

  def to_unicode(str)
    str.unpack('U*').map{ |i| "\\u" + i.to_s(16).rjust(4, '0') }.join
  end
end