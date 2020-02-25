RSpec.describe AuthorizingCenter::UcCenter do
  before(:each) do
    allow(AuthorizingCenter::UcCenter).to receive(:encrypt).and_return('foobar')
    AuthorizingCenter.uc_center_endpoint = 'https://test.com'
    AuthorizingCenter.uc_center_encrypt_key = 'foobar'
  end
  let(:username) { 'username' }
  let(:password) { 'password' }
  let(:ip) { '127.0.0.1' }

  it 'return true when username available' do
    username = 'wrong'
    stub_request(:post, AuthorizingCenter.uc_center_endpoint)
      .with(body: {
        username: username,
        aj: 1,
        m: 'user',
        a: 'usernamecheck'
      })
      .to_return(status: 200, body: '1')

    name_available = AuthorizingCenter::UcCenter.name_available?(username)

    expect(name_available).to eq(true)
  end

  it 'return false when wrong account' do
    username = 'wrong'
    user = AuthorizingCenter::UcCenter.new(username, password, ip)

    allow(user).to receive(:desurl).and_return('foobar')

    stub_request(:post, AuthorizingCenter.uc_center_endpoint)
      .with(body: {a: "getticket", desurl: "foobar", m: "api", username: "wrong"})
      .to_return(status: 200, body: '-1')

    expect(user.login).to eq(false)
    expect(user.http_code).to eq(200)
    expect(user.response).to eq({ data: '帐号或密码错误' }.as_json)
  end

  it 'return JSON info when account valid' do
    user_info = {
      'vip' => Faker::Number.between(from: 1, to: 10),
      'money' => Faker::Number.between(from: 1, to: 1000),
      'mode' => Faker::Number.between(from: 1, to: 3),
      'type' => Faker::Number.between(from: 1, to: 3),
      'status' => Faker::Number.between(from: 1, to: 3),
      'name' => Faker::Name.name
    }
    url = AuthorizingCenter.uc_center_endpoint + "?#{{a: 'userinfo', m: 'api', username: username}.to_query}"
    user = AuthorizingCenter::UcCenter.new(username, password, ip)

    allow(user).to receive(:desurl).and_return('foobar')

    stub_request(:post, AuthorizingCenter.uc_center_endpoint)
      .with(body: {a: "getticket", desurl: "foobar", m: "api", username: username})
      .to_return(status: 200, body: 'dewdedcwevdwevf')

    stub_request(:get, url).to_return(status: 200, body: user_info.to_json)

    response = { data: user_info }.as_json

    expect(user.login).to eq(response)
    expect(user.response).to eq(response)
  end
end