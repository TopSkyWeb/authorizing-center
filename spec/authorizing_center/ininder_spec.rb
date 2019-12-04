RSpec.describe AuthorizingCenter::Ininder do
  before(:each) do
    AuthorizingCenter.ininder_endpoint = 'https://test.com'
  end
  it 'will return false when request respond 403 , username or password is wrong' do
    stub_request(:post, AuthorizingCenter.ininder_endpoint + '/api/v1/admin/login').
        with(body: {account: :foo, password: :bar}.to_query).
        to_return(status: 403, body: '{"message":"Validation Failed","errors":{"info":["\u5e10\u53f7\/\u5bc6\u7801\u9519\u8bef \u6216 \u8d26\u53f7\u51bb\u7ed3\u4e2d"]}}')
    expect(AuthorizingCenter::Ininder.authorize?('foo', 'bar')).to eq false
  end
  it 'will return true when request respond 200 , username or password is correct, and body will respond jwt token' do
    stub_request(:post, AuthorizingCenter.ininder_endpoint + '/api/v1/admin/login').
        with(body: {account: :foo, password: :bar}.to_query).
        to_return(status: 200, body: {data: 'success'}.to_json)

    stub_request(:get, AuthorizingCenter.ininder_endpoint + '/api/v1/internal/admin').
      to_return(status: 200, body: {data: 'success'}.to_json)

    expect(AuthorizingCenter::Ininder.authorize?('foo', 'bar')).to eq({data: 'success'}.as_json)
  end
end