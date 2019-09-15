module AuthorizingCenter
  # Checks the scope in the given environment and returns the associated failure app.
  module UcCenter
    def self.authorize?(username, password)
      site = AuthorizingCenter.uc_center_endpoint
      string_wait_for_encrypt = {password: password, destime: Time.now.to_i}.to_query
      post_filed = {username: username, desurl: encrypt(string_wait_for_encrypt), m: 'api', a: 'getticket'}
      respond = site.post post_filed.to_query
      UC_GET_TICKET_ERROR_CODE.has_key?(respond.body) ? false : true
    end

    def self.user_information(username)
      url = "#{AuthorizingCenter.uc_center_endpoint}?#{{a: 'userinfo', m: 'api', username: username}.to_query}"
      respond = RestClient.get url
      user_info = JSON.parse respond.body
      user_info
    end

    private

    def encrypt(str)
      iv = OpenSSL::Random.random_bytes(16)
      key = AuthorizingCenter.uc_center_encrypt_key.ljust(32, 0.chr)
      cipher = SymmetricEncryption::Cipher.new(key: key, iv: iv, encoding: :base64, always_add_header: false, cipher_name: 'aes-256-cbc')
      data = cipher.encrypt(str)
      Base64.urlsafe_encode64("#{data}::#{iv}")
    end
  end
end