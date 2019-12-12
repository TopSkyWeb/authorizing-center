module AuthorizingCenter
  # Checks the scope in the given environment and returns the associated failure app.
  class Ininder
    attr_reader :http_code, :response

    def initialize(username, password)
      @site = RestClient::Resource.new(AuthorizingCenter.ininder_endpoint)
      @username = username
      @password = password
    end

    def login
      begin
        login = @site['/api/v1/admin/login'].post(params)
        token = JSON.parse(login.body)['data']
        response = @site['/api/v2/internal/admin'].get(Authorization: "Bearer #{token}")
      rescue => exception
        response = exception.response
      end

      @http_code = response.code
      @response = JSON.parse(response)

      @http_code === 200 ? @response : false
    end

    private

    def params
      { account: @username, password: @password }
    end
  end
end