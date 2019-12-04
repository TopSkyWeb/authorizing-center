module AuthorizingCenter
  # Checks the scope in the given environment and returns the associated failure app.
  class Ininder
    def self.authorize?(username, password)
      post_fields = {account: username, password: password}
      site = RestClient::Resource.new(AuthorizingCenter.ininder_endpoint)
      begin
        login = site['/api/v1/admin/login'].post post_fields.to_query
        login = JSON.parse(login.body)
      rescue
        false
      else
        token = login['data']
        user_info = site['/api/v1/internal/admin'].get Authorization: "Bearer #{token}"
        JSON.parse(user_info.body)
      end
    end
  end
end