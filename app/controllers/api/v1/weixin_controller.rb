require 'ldap'
require 'aes'
module Api
  module V1
    class WeixinController < Api::V1::ApplicationController
      def auth
        aes = Aes.new
        ldap = Ldap.new
        weixin_request = JSON.parse(aes.decrypt params["raw_data"])
        result = ldap.weixin_raw_data weixin_request["card_number"], weixin_request["password"]
        if result
          @raw_data = aes.encrypt result
        else
          render json: {
            "code" => 1,
            'errmsg' => 'Login error!'
        }
        end
      end
    end
  end
end