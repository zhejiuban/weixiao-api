require 'ldap'
require 'aes'
module Api
  module V1
    class WeixinController < Api::V1::ApplicationController
      def auth
        aes = Aes.new
        ldap = Ldap.new
        weixin_request = JSON.parse(aes.decrypt params["raw_data"])
        result = ldap.auth_with_database weixin_request["card_number"], weixin_request["password"]
        if result
          @raw_data = aes.encrypt result
        else
          render json: {
            "code" => 1,
            'message' => '账号或密码不正确，请检查后重新输入!',
            "app_key" => Rails.application.credentials[Rails.env.to_sym][:app_key]
        }
        end
      end
    end
  end
end