require "symmetric-encryption"
module AuthorizingCenter
  # Checks the scope in the given environment and returns the associated failure app.
  class UcCenter

    UC_GET_TICKET_ERROR_CODE = {
      '-1' => '帐号或密码错误',
      '-2' => '帐号或密码错误',
      '-3' => 'IP被封15分钟',
      '-4' => '帐号被停用',
      'time out!' => '令牌逾时，请重新开启APP在尝试一次'
    }

    attr_reader :http_code, :response, :ticket

    def initialize(username, password, remote_ip)
      @site = RestClient::Resource.new(AuthorizingCenter.uc_center_endpoint)
      @username = username
      @password = password
      @remote_ip = remote_ip
    end

    def name_available?
      response = @site.post({
        username: username,
        aj: 1,
        m: 'user',
        a: 'usernamecheck'
      })

      response.body.to_i == 1
    end

    def login
      begin
        response = @site.post(ticket_params)
        if UC_GET_TICKET_ERROR_CODE.has_key?(response.body)
          message = UC_GET_TICKET_ERROR_CODE[response.body]
          @response = to_data_json(message)
          @http_code = response.code
          return false
        else
          @ticket = response.body
          response = RestClient.get("#{AuthorizingCenter.uc_center_endpoint}?#{user_info_params.to_query}")
        end
      rescue => exception
        response = exception.response
      end

      @response = to_data_json(response.body)
      @http_code = response.code

      @http_code === 200 && @ticket ? @response : false
    end

    private

    def to_data_json(string)
      begin
        data = JSON.parse(string)
      rescue
        data = string
      end

      data['data'] ? data : { data: data }.as_json
    end

    def ticket_params
      {
        username: @username,
        desurl: desurl,
        m: 'api',
        a: 'getticket'
      }
    end

    def user_info_params
      {
        username: @username,
        m: 'api',
        a: 'userinfo'
      }
    end

    def desurl
      str = {
        password: @password,
        destime: Time.now.to_i,
        ip: @remote_ip
      }.to_query

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