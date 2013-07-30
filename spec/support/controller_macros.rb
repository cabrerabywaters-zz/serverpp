# Public: Permite logear usuario para los diferentes test.
#
module ControllerMacros
  include Devise::TestHelpers

  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      @current_admin = FactoryGirl.create(:admin)
      sign_in @current_admin
    end
  end

  def login_user_efi
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user_efi]
      @current_user_efi = FactoryGirl.create(:user_efi)
      sign_in @current_user_efi
    end
  end

  def login_user_eco
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user_eco]
      @current_user_eco = FactoryGirl.create(:user_eco)
      sign_in @current_user_eco
    end
  end
end
