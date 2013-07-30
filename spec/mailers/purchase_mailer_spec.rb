require "spec_helper"

describe PurchaseMailer do
  describe "voucher" do
    purchase = FactoryGirl.create(:purchase)

    subject {
      PurchaseMailer.voucher(purchase)
    }

    it "should be delivered to the email in purchase" do
      should deliver_to(purchase.email)
    end

    it "should contain the purchase code in the mail body" do
      should have_body_text(purchase.code)
    end
  end
end
