require 'spec_helper'

describe Eco::BillingsController do
  login_user_eco

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

end
