RSpec.describe AuthorizingCenter::UcCenter do
  before(:each) do
    allow(AuthorizingCenter::UcCenter).to receive(:encrypt).and_return('foobar')
    AuthorizingCenter.uc_center_endpoint = 'https://test.com'
    AuthorizingCenter.uc_center_encrypt_key = 'foobar'
  end
  let(:username) {:foo}
  it 'should return false when request respond 200 but body include error code, username or password is wrong' do
    stub_request(:post, AuthorizingCenter.uc_center_endpoint).
        with(body: {username: username, desurl: :foobar, m: :api, a: :getticket}.to_query).
        to_return(status: 200, body: AuthorizingCenter::UC_GET_TICKET_ERROR_CODE.keys.sample)
    expect(AuthorizingCenter::UcCenter.authorize?(username, :bar)).to eq false
  end
  it 'should return true when request respond 200 and body not include error code, username or password is correct' do
    stub_request(:post, AuthorizingCenter.uc_center_endpoint).
        with(body: {username: username, desurl: :foobar, m: :api, a: :getticket}.to_query).
        to_return(status: 200, body: Faker::String.random(length: 15))
    expect(AuthorizingCenter::UcCenter.authorize?(username, :bar)).to eq true
  end
  it 'should return user information from API, and return value only pass from API' do
    user_information = {
        'vip' => Faker::Number.between(from: 1, to: 10),
        'money' => Faker::Number.between(from: 1, to: 1000),
        'mode' => Faker::Number.between(from: 1, to: 3),
        'type' => Faker::Number.between(from: 1, to: 3),
        'status' => Faker::Number.between(from: 1, to: 3),
        'name' => Faker::Name.name
    }
    stub_request(:get, AuthorizingCenter.uc_center_endpoint+"?#{{a: 'userinfo', m: 'api', username: username}.to_query}").
        to_return(status: 200, body: user_information.to_json)
    expect(AuthorizingCenter::UcCenter.user_information(username)).to eq user_information
  end
end