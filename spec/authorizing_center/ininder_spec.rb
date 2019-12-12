RSpec.describe AuthorizingCenter::Ininder do
  before(:each) do
    AuthorizingCenter.ininder_endpoint = 'https://test.com'
  end
  it 'return false when wrong account' do
    stub_request(:post, AuthorizingCenter.ininder_endpoint + '/api/v1/admin/login')
      .with(body: { account: :foo, password: :bar }.to_query)
      .to_return(status: 403, body: '{"message":"Validation Failed","errors":{"info":["\u5e10\u53f7\/\u5bc6\u7801\u9519\u8bef \u6216 \u8d26\u53f7\u51bb\u7ed3\u4e2d"]}}')

    user = AuthorizingCenter::Ininder.new('foo', 'bar')

    expect(user.login).to eq(false)
  end
  it 'return JSON info when account valid' do
    stub_request(:post, AuthorizingCenter.ininder_endpoint + '/api/v1/admin/login')
      .with(body: { account: :foo, password: :bar }.to_query)
      .to_return(status: 200, body: { data: 'success' }.to_json)

    stub_request(:get, AuthorizingCenter.ininder_endpoint + '/api/v2/internal/admin').
      to_return(status: 200, body: { data: 'success' }.to_json)

    user = AuthorizingCenter::Ininder.new('foo', 'bar')

    expect(user.login).to eq({ data: 'success' }.as_json)
  end
end