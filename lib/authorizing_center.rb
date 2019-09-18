require "authorizing_center/version"
require "rest-client"
require "rails"
module AuthorizingCenter
  autoload :Ininder, 'authorizing_center/ininder'
  autoload :UcCenter, 'authorizing_center/uc_center'

  # UC Get Ticket API Error Code
  UC_GET_TICKET_ERROR_CODE = {
      '-1' => '帐号或密码错误',
      '-2' => '帐号或密码错误',
      '-3' => 'IP被封15分钟',
      '-4' => '帐号被停用'
  }

  # Uc Center Endpoint
  mattr_accessor :uc_center_endpoint
  @@uc_center_endpoint = nil

  mattr_accessor :uc_center_encrypt_key
  @@uc_center_encrypt_key = nil

  mattr_accessor :ininder_endpoint
  @@ininder_endpoint = nil

  mattr_accessor :error_message
  @@ininder_endpoint = nil

  def self.setup
    yield self
  end
end
