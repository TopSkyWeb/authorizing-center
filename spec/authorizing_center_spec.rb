require 'spec_helper'
RSpec.describe AuthorizingCenter do
  it "has a version number" do
    expect(AuthorizingCenter::VERSION).not_to be nil
  end

  it "has a constant to record error code from UC center" do
    expect(AuthorizingCenter::UC_GET_TICKET_ERROR_CODE).not_to be nil
    expect(AuthorizingCenter::UC_GET_TICKET_ERROR_CODE.class).to be Hash
  end
end
