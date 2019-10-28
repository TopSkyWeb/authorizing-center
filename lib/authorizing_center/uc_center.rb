require "symmetric-encryption"
module AuthorizingCenter
  # Checks the scope in the given environment and returns the associated failure app.
  module UcCenter
    def self.authorize?(username, password)
      site = RestClient::Resource.new(AuthorizingCenter.uc_center_endpoint)
      string_wait_for_encrypt = {password: password, destime: Time.now.to_i, ip: request.remote_ip}.to_query
      post_filed = {username: username, desurl: AuthorizingCenter::UcCenter.encrypt(string_wait_for_encrypt), m: 'api', a: 'getticket'}
      respond = site.post post_filed.to_query
      if UC_GET_TICKET_ERROR_CODE.has_key?(respond.body)
        AuthorizingCenter.error_message = UC_GET_TICKET_ERROR_CODE[respond.body]
        false
      else
        true
      end
    end

    def self.user_information(username)
      url = "#{AuthorizingCenter.uc_center_endpoint}?#{{a: 'userinfo', m: 'api', username: username}.to_query}"
      respond = RestClient.get url
      user_info = JSON.parse respond.body
      user_info
    end

    def self.encrypt(str)
      # php base64 complies with RFC 1421  , rails base64 complies with RFC 2045, if include + , regenerate again
      loop do
        iv = OpenSSL::Random.random_bytes(16)
        key = AuthorizingCenter.uc_center_encrypt_key.ljust(32, 0.chr)
        cipher = SymmetricEncryption::Cipher.new(key: key, iv: iv, encoding: :base64, always_add_header: false, cipher_name: 'aes-256-cbc')
        data = cipher.encrypt(str)
        encrypt_string = Base64.encode64("#{data}::#{iv}")
        return encrypt_string unless encrypt_string.include?('+')
      end
    end
  end
end