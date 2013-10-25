# encoding: utf-8
require 'spec_helper'

describe Purchase do
   ##############
  # attributes #
  ##############
  describe "attributes" do
    it "debe responder a rut" do
      should respond_to :rut
    end

    it "debe responder a email" do
      should respond_to :email
    end

    it "debe responder a password" do
      should respond_to :password
    end

    it "debe responder a exchange_id" do
      should respond_to :exchange_id
    end

    it "debe responder a code" do
      should respond_to :code
    end

    it "debe responder a reference_codes" do
      should respond_to :reference_codes
    end

    it "debe responder a required_password" do
      should respond_to :required_password
    end

    it "debe responder a confirmed_at" do
      should respond_to :confirmed_at
    end

    it "debe responder a token" do
      should respond_to :token
    end
  end

  ################
  # associations #
  ################
  describe "associations" do
    it "debe pertenecer a un exchange" do
      should belong_to(:exchange)
    end
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:purchase).should be_valid
  end

  it "debe requerir un exchange_id" do
    FactoryGirl.build(:purchase, exchange_id: nil).should_not be_valid
    FactoryGirl.build(:purchase, exchange_id: '').should_not be_valid
  end

  context "al crear" do
    it "debe requerir un password" do
      purchase = FactoryGirl.build(:purchase)

      purchase.password = nil
      purchase.should_not be_valid

      purchase.password = ''
      purchase.should_not be_valid
    end

    it "debe no requerir un password si required_password is false" do
      purchase = FactoryGirl.build(:purchase)

      purchase.required_password = false
      purchase.password = nil
      purchase.should be_valid
    end
  end

  describe "code" do
    it "debe crear un codigo por defecto" do
      FactoryGirl.create(:purchase).code.should_not be_nil
    end

    it "debe requerir un code único" do
      FactoryGirl.create(:purchase, code: 'alfa')
      FactoryGirl.build(:purchase,  code: 'alfa').should_not be_valid
    end
  end

  describe "token" do
    it "debe crear un token por defecto" do
      FactoryGirl.create(:purchase).token.should_not be_nil
    end

    it "debe requerir un token único" do
      FactoryGirl.create(:purchase, token: 'alfa')
      FactoryGirl.build(:purchase,  token: 'alfa').should_not be_valid
    end
  end

  it "debe requerir un rut" do
    FactoryGirl.build(:purchase, rut: nil).should_not be_valid
    FactoryGirl.build(:purchase, rut: '').should_not  be_valid
  end

  it "debe requerir un email" do
    FactoryGirl.build(:purchase, email: nil).should_not be_valid
    FactoryGirl.build(:purchase, email: '').should_not  be_valid
  end

  it "debe requerir un rut válido" do
    FactoryGirl.build(:purchase, rut: '11111111 1'  ).should_not be_valid
    FactoryGirl.build(:purchase, rut: '11.111.111 1').should_not be_valid
    FactoryGirl.build(:purchase, rut: '11 111 111 1').should_not be_valid
    FactoryGirl.build(:purchase, rut: '11111.1111'  ).should_not be_valid
    FactoryGirl.build(:purchase, rut: '11111.111-1' ).should_not be_valid
    FactoryGirl.build(:purchase, rut: '11.1111111'  ).should_not be_valid
    FactoryGirl.build(:purchase, rut: '11.111111-1' ).should_not be_valid
    FactoryGirl.build(:purchase, rut: '11.111.1111' ).should_not be_valid
    FactoryGirl.build(:purchase, rut: '11.111.111.1').should_not be_valid

    FactoryGirl.build(:purchase, rut: '111111111'   ).should be_valid
    FactoryGirl.build(:purchase, rut: '11111111-1'  ).should be_valid
    FactoryGirl.build(:purchase, rut: '11.111.111-1').should be_valid

    FactoryGirl.build(:purchase, rut: Run.for(:purchase, :rut)).should be_valid
  end

  context "cuando se trata de un evento sin exclusividad" do
    it "debe validar la cantidad de cupones del event" do
      experience = FactoryGirl.create(:experience, total_exclusivity_sales: false, by_industry_exclusivity_sales: false)
      event      = FactoryGirl.create(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id, swaps: 2)
      exchange   = event.exchanges.last

      FactoryGirl.create(:purchase, exchange_id: exchange.id)
      FactoryGirl.create(:purchase, exchange_id: exchange.id)
      FactoryGirl.build(:purchase,  exchange_id: exchange.id).should_not be_valid
    end

    it "debe validar la cantidad de cupones disponibles del event" do
      experience = FactoryGirl.create(:experience)
      experience.starting_at = Date.today - 4.days
      experience.save validate: false

      industry1  = FactoryGirl.create(:industry)
      industry2  = FactoryGirl.create(:industry)
      efi        = FactoryGirl.create(:efi, industry_ids: [industry1.id])

      experience.industry_experiences.destroy_all
      FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry1.id, percentage: 90.0)
      FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry2.id, percentage: 10.0)
      experience.reload

      event      = FactoryGirl.create(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id, swaps: experience.swaps)
      event2     = FactoryGirl.create(:event, efi_id: efi.id, experience_id: experience.id, exclusivity_id: Exclusivity.by_industry_id)
      exchange   = event.exchanges.last

      (event.swaps - event2.quantity).times.each do |index|
        FactoryGirl.create(:purchase, exchange_id: exchange.id)
      end

      FactoryGirl.build(:purchase, exchange_id: exchange.id).should_not be_valid
    end
  end

  context "cuando se trata de un evento con exclusividad por industria" do
    it "debe validar la cantidad de cupones del event" do
      experience = FactoryGirl.create(:experience, swaps: 10, total_exclusivity_sales: false)
      industry   = experience.industry_experiences.first.industry
      efi        = FactoryGirl.create(:efi, industry_ids: [industry.id])

      event      = FactoryGirl.create(:event, efi_id: efi.id, experience_id: experience.id, exclusivity_id: Exclusivity.by_industry_id)
      exchange   = event.exchanges.last

      FactoryGirl.build(:purchase, exchange_id: exchange.id).should be_valid

      event.quantity.times.each do |index|
        FactoryGirl.create(:purchase, exchange_id: exchange.id)
      end

      FactoryGirl.build(:purchase, exchange_id: exchange.id).should_not be_valid
    end
  end

  context "cuando se trata de un evento con exclusividad total" do
    it "debe validar la cantidad de cupones del event" do
      experience = FactoryGirl.create(:experience, swaps: 1, codes: [], codes_by_purchase: nil)
      event = FactoryGirl.create(:event, experience_id: experience.id, exclusivity_id: Exclusivity.total_id)
      FactoryGirl.create(:purchase, exchange_id: event.exchanges.last.id)
      FactoryGirl.build(:purchase, exchange_id: event.exchanges.last.id).should_not be_valid
    end
  end


  describe "reference_codes" do
    it "debe asignar los reference_codes por defecto" do
      FactoryGirl.create(:purchase).reference_codes.should_not be_empty
    end

    it "debe asignar tantos reference_codes como se indique en la experiencia" do
      purchase = FactoryGirl.create(:purchase)
      purchase.reference_codes.count.should eq(purchase.exchange.event.experience.codes_by_purchase)
    end

    it "debe aceptar reference_codes random si no se suben codigos" do
      experience = FactoryGirl.create(:experience, codes: [], codes_by_purchase: nil)
      event = FactoryGirl.create(:event, experience_id: experience.id)
      exchange = event.exchanges.last

      experience.codes.should be_empty

      purchase = FactoryGirl.create(:purchase, exchange_id: exchange.id)
      purchase.should be_valid

      experience.codes.include?(purchase.reference_codes.first).should be_false
    end

    context "single code by purchase" do
      it "debe requerir un reference_codes segun los codigos de la experience" do
        experience = FactoryGirl.create(:experience, codes: ['a', 'b'], swaps: 2, codes_by_purchase: 1)
        event = FactoryGirl.create(:event, experience_id: experience.id)
        exchange = event.exchanges.last

        FactoryGirl.build(:purchase, exchange_id: exchange.id).should be_valid
        FactoryGirl.build(:purchase, exchange_id: exchange.id, reference_codes: ['a']).should be_valid
        FactoryGirl.build(:purchase, exchange_id: exchange.id, reference_codes: ['b']).should be_valid

        FactoryGirl.build(:purchase, exchange_id: exchange.id, reference_codes: ['c']).should_not be_valid
      end

      it "debe requerir un reference_codes disponible" do
        experience = FactoryGirl.create(:experience, codes: ['a', 'b'], swaps: 2, codes_by_purchase: 1)
        event = FactoryGirl.create(:event, experience_id: experience.id)
        exchange = event.exchanges.last

        FactoryGirl.create(:purchase, exchange_id: exchange.id, reference_codes: ['a'])
        FactoryGirl.build(:purchase, exchange_id: exchange.id,  reference_codes: ['a']).should_not be_valid

        FactoryGirl.build(:purchase, exchange_id: exchange.id,  reference_codes: ['b']).should be_valid
      end
    end

    context "multi code by purchase" do
      it "debe requerir un reference_codes segun los codigos de la experience" do
        experience = FactoryGirl.create(:experience, codes: ['a', 'b', 'c', 'd'], swaps: 2, codes_by_purchase: 2)
        event = FactoryGirl.create(:event, experience_id: experience.id)
        exchange = event.exchanges.last

        FactoryGirl.build(:purchase, exchange_id: exchange.id).should be_valid
        FactoryGirl.build(:purchase, exchange_id: exchange.id, reference_codes: ['a', 'b']).should be_valid
        FactoryGirl.build(:purchase, exchange_id: exchange.id, reference_codes: ['c', 'd']).should be_valid

        FactoryGirl.build(:purchase, exchange_id: exchange.id, reference_codes: ['a', 'f']).should_not be_valid
        FactoryGirl.build(:purchase, exchange_id: exchange.id, reference_codes: ['f', 'b']).should_not be_valid
        FactoryGirl.build(:purchase, exchange_id: exchange.id, reference_codes: ['f', 'g']).should_not be_valid
      end

      it "debe requerir un reference_codes disponible" do
        experience = FactoryGirl.create(:experience, codes: ['a', 'b', 'c', 'd'], swaps: 2, codes_by_purchase: 2)
        event = FactoryGirl.create(:event, experience_id: experience.id)
        exchange = event.exchanges.last

        FactoryGirl.create(:purchase, exchange_id: exchange.id, reference_codes: ['a', 'b'])

        FactoryGirl.build(:purchase, exchange_id: exchange.id,  reference_codes: ['a', 'b']).should_not be_valid
        FactoryGirl.build(:purchase, exchange_id: exchange.id,  reference_codes: ['b', 'c']).should_not be_valid

        FactoryGirl.build(:purchase, exchange_id: exchange.id,  reference_codes: ['c', 'd']).should be_valid
      end
    end
  end

  ###########
  # methods #
  ###########
  context 'para obtener el estado en que se encuentra la purchase' do
    it "debe responder a translate_state" do
      should respond_to :translate_state
    end
  end

  describe "Para validar un compra y cambiarla de estado" do
    it "debe responder a validate!" do
      should respond_to :validate!
    end
  end

  describe "no elimina compras pero si las oculta" do
    it "debe ocultar por defecto las compras redeem" do
      Purchase.count.should eq(0)
      FactoryGirl.create(:purchase, state: 'redeemed')
      Purchase.count.should eq(0)

      Purchase.unscoped.count.should eq(1)
    end
  end

  describe "para validar el stock del evento" do
    it "debe responder a check_event_stock!" do
      should respond_to :check_event_stock!
    end
  end

  #################
  # state_machine #
  #################
  describe "state_machine" do
    context "states" do
      it "debe tener estados" do
        FactoryGirl.create(:purchase, state: 'redeemed').should be_valid
        FactoryGirl.create(:purchase, state: 'sold').should be_valid
        FactoryGirl.create(:purchase, state: 'validated').should be_valid

        expect {
          FactoryGirl.create(:purchase, state: 'otro_estado_no_valido')
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
    context "events" do
      describe "redeem!" do
        it "debe cambiar el estado" do
          purchase = FactoryGirl.create(:purchase, state: 'sold')
          purchase.redeem!.should be_true
          purchase.redeemed?.should be_true
        end
        it "no debe cambiar el estado" do
          purchase = FactoryGirl.create(:purchase, state: 'validated')
          purchase.redeem!.should be_false
          purchase.redeemed?.should be_false
          purchase.validated?.should be_true
        end
      end

      describe "validate!" do
        it "debe cambiar el estado" do
          purchase = FactoryGirl.create(:purchase, state: 'sold')
          purchase.sold?.should be_true
          purchase.validate!.should be_true
          purchase.validated?.should be_true
        end

        it "no debe cambiar el estado" do
          ['redeemed', 'validated'].each do |s|
            purchase = FactoryGirl.create(:purchase, state: s)
            purchase.sold?.should be_false
            purchase.validate!.should be_false
          end
        end
      end
    end
  end
end
