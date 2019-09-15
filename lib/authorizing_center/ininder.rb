module AuthorizingCenter
  # Checks the scope in the given environment and returns the associated failure app.
  class Ininder
    def self.authorize?(username, password)
      post_fields = {account: username, password: password}
      site = AuthorizingCenter.ininder_endpoint
      begin
        site['/api/v1/admin/login'].post post_fields.to_query
      rescue
        false
      else
        true
      end
    end
  end
end