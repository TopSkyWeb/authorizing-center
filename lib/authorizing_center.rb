require "authorizing_center/version"
module AuthorizingCenter
  autoload :Ininder, 'authorizing_center/ininder'
  autoload :UcCenter, 'authorizing_center/uc_center'

  # UC Get Ticket API Error Code
  UC_GET_TICKET_ERROR_CODE = {
      '-1' => '帐号不存在',
      '-2' => '密码错误',
      '-3' => 'IP被封15分钟',
      '-4' => '帐号被停用'
  }

  # Uc Center Endpoint
  attr_accessor :uc_center_endpoint
  @@uc_center_endpoint = nil

  attr_accessor :uc_center_encrypt_key
  @@uc_center_encrypt_key = nil

  attr_accessor :ininder_endpoint
  @@ininder_endpoint = nil

end
