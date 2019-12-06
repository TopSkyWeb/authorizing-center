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
      post_fields = { account: @username, password: @password }
      begin
        login = @site['/api/v1/admin/login'].post(post_fields.to_query)
        token = JSON.parse(login.body)['data']
      rescue => exception
        response = exception.response
      else
        response = @site['/api/v2/internal/admin'].get(Authorization: "Bearer #{token}")
      end
      @http_code = response.code
      @response = JSON.parse(response)
    end

    def authorize?
       @http_code === 200
    end
  end
end