# encoding: utf-8
require 'spec_helper'

describe Event do
  ##############
  # attributes #
  ##############
  describe "attributes" do
    it "debe responder a quantity" do
      should respond_to :quantity
    end

    it "debe responder a exclusivity_id" do
      should respond_to :exclusivity_id
    end

    it "debe responder a swaps" do
      should respond_to :swaps
    end

    it "debe responder a efi_id" do
      should respond_to :efi_id
    end

    it "debe responder a experience_id" do
      should respond_to :experience_id
    end

    it "debe responder a state" do
      should respond_to :state
    end

    it "debe responder a sold_at" do
      should respond_to :sold_at
    end
  end

  ################
  # associations #
  ################
  it "debe pertenecer a efi" do
    should belong_to(:efi)
  end

  it "debe pertenecer a efi" do
    should belong_to(:experience)
  end

  it "debe tener muchos exchanges" do
    should have_many(:exchanges).dependent(:destroy)
  end

  it "debe tener muchos purchases" do
    should have_many(:purchases).through(:exchanges)
  end

  it "debe tener muchos banners" do
    should have_many(:banners).dependent(:destroy)
  end

  it "debe tener muchos publicities" do
    should have_many(:publicities).dependent(:destroy)
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:event).should be_valid
  end

  describe ":exclusivity_id validations" do
    it "debe requerir un exclusivity_id" do
      FactoryGirl.build(:event, exclusivity_id: nil).should_not be_valid
      FactoryGirl.build(:event, exclusivity_id: '').should_not be_valid
    end

    context "debe requerir un exclusivity_id valido" do
      it "solo exclusividad total" do
        experience = FactoryGirl.create(:experience,
                                        total_exclusivity_sales:       true,  total_exclusivity_days:       nil,
                                        by_industry_exclusivity_sales: false, by_industry_exclusivity_days: nil,
                                        without_exclusivity_sales:     false)

        FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.by_industry_id).should_not be_valid
        FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id).should_not be_valid

        FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.total_id).should be_valid
      end
      it "solo exclusividad por industria" do
        experience = FactoryGirl.create(:experience,
                                        total_exclusivity_sales:       false, total_exclusivity_days:       nil,
                                        by_industry_exclusivity_sales: true,  by_industry_exclusivity_days: nil,
                                        without_exclusivity_sales:     false)

        FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.total_id).should_not be_valid
        FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id).should_not be_valid

        FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.by_industry_id).should_not be_valid
      end
      it "solo sin exclusividad" do
        experience = FactoryGirl.create(:experience,
                                        total_exclusivity_sales:       false, total_exclusivity_days:       nil,
                                        by_industry_exclusivity_sales: false, by_industry_exclusivity_days: nil,
                                        without_exclusivity_sales:     true)

        FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.total_id).should_not be_valid
        FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.by_industry_id).should_not be_valid

        FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id, swaps: 10).should be_valid
      end

      it "segun duraciones" do
        experience = FactoryGirl.create(:experience,
                                        total_exclusivity_sales:       true, total_exclusivity_days:       2,
                                        by_industry_exclusivity_sales: true, by_industry_exclusivity_days: 3,
                                        without_exclusivity_sales:     true)

        industry   = experience.industry_experiences.first.industry
        efi        = FactoryGirl.create(:efi, industry_ids: [industry.id])

        day = experience.starting_at

        FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.total_id).should be_valid
        FactoryGirl.build(:event, efi_id: efi.id, experience_id: experience.id, exclusivity_id: Exclusivity.by_industry_id).should_not be_valid
        FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id, swaps: 10).should_not be_valid

        experience.starting_at = day - 2.days
        experience.save(validate: false)
        FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.total_id).should be_valid
        FactoryGirl.build(:event, efi_id: efi.id, experience_id: experience.id, exclusivity_id: Exclusivity.by_industry_id).should be_valid
        FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id, swaps: 10).should_not be_valid

        experience.starting_at = day - 5.days
        experience.save(validate: false)
        FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.total_id).should be_valid
        FactoryGirl.build(:event, efi_id: efi.id, experience_id: experience.id, exclusivity_id: Exclusivity.by_industry_id).should be_valid
        FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id, swaps: 10).should be_valid
      end
    end
  end

  it "debe requerir un efi_id" do
    FactoryGirl.build(:event, efi_id: nil).should_not be_valid
    FactoryGirl.build(:event, efi_id: '').should_not be_valid
  end

  it "debe requerir un experience_id" do
    FactoryGirl.build(:event, experience_id: nil).should_not be_valid
    FactoryGirl.build(:event, experience_id: '').should_not be_valid
  end

  it "debe requerir un exchange" do
    event = FactoryGirl.build(:event)
    event.exchanges.destroy_all
    event.should_not be_valid
  end

  it "debe validar de forma única el evento para una EFI y Experience determinadas" do
    experience = FactoryGirl.create(:experience)
    efi        = FactoryGirl.create(:efi)

    FactoryGirl.create(:event, efi_id: efi.id, experience_id: experience.id)
    FactoryGirl.build(:event,  efi_id: efi.id, experience_id: experience.id).should_not be_valid
  end

  context "cuando se trata de un evento 'sin exclusividad'" do
    it "no debe requerir un quantity" do
      experience = FactoryGirl.create(:experience, swaps: 10, total_exclusivity_sales: false, by_industry_exclusivity_sales: false)
      FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id, swaps: experience.minimum_without_swaps, quantity: nil).should be_valid
      FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id, swaps: experience.minimum_without_swaps, quantity: '').should be_valid
    end

    it "debe requerir un swaps" do
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.without_id, swaps: nil).should_not be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.without_id, swaps: '').should_not be_valid
    end

    it "debe requerir un swaps numerico" do
      subject.stub(:exclusivity_id){Exclusivity.without_id}
      should validate_numericality_of :swaps

      FactoryGirl.build(:event, exclusivity_id: Exclusivity.without_id, swaps: 'a').should_not be_valid
    end

    it "debe requerir un swaps mayor a 0" do
      experience = FactoryGirl.create(:experience, swaps: 10)
      FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id, swaps: '-1').should_not be_valid
      FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id, swaps: -1).should_not be_valid
      FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id, swaps: '0').should_not be_valid
      FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id, swaps: 0).should_not be_valid
    end

    it "debe requerir un swaps minimo" do
      experience = FactoryGirl.create(:experience, swaps: 100, codes: [], codes_by_purchase: nil, total_exclusivity_sales: false, by_industry_exclusivity_sales: false)

      [*1..experience.minimum_without_swaps-1].each do |i|
        FactoryGirl.build(:event, exclusivity_id: Exclusivity.without_id, experience_id: experience.id, swaps: i).should_not be_valid
      end

      FactoryGirl.build(:event, exclusivity_id: Exclusivity.without_id, experience_id: experience.id, swaps: experience.minimum_without_swaps).should be_valid
    end

    context "cuando no hay empresas participando de la experience" do
      it "debe requerir un swaps inferior o igual al total de swaps de la experience" do
        experience = FactoryGirl.create(:experience, swaps: 2, codes: [], codes_by_purchase: nil, total_exclusivity_sales: false, by_industry_exclusivity_sales: false)
        FactoryGirl.build(:event, exclusivity_id: Exclusivity.without_id, experience_id: experience.id, swaps: 1).should be_valid
        FactoryGirl.build(:event, exclusivity_id: Exclusivity.without_id, experience_id: experience.id, swaps: 2).should be_valid
        FactoryGirl.build(:event, exclusivity_id: Exclusivity.without_id, experience_id: experience.id, swaps: 3).should_not be_valid
      end
    end

    context "cuando ya tomaron la exclusividad total" do
      it "no debe permitir nuevos eventos" do
        experience = FactoryGirl.create(:experience, swaps: 30, codes: [], codes_by_purchase: nil)
        FactoryGirl.create(:event, exclusivity_id: Exclusivity.total_id,   experience_id: experience.id)
        FactoryGirl.build(:event,  exclusivity_id: Exclusivity.without_id, experience_id: experience.id, swaps: 1).should_not be_valid
      end
    end

    context "cuando ya tomaron la exclusividad por industria" do
      it "debe requerir un swaps inferior al total disponible" do
        experience = FactoryGirl.create(:experience, swaps: 100, codes: [], codes_by_purchase: nil, total_exclusivity_sales: false)
        experience.starting_at = Date.today - 4.days
        experience.save validate: false

        industry1  = FactoryGirl.create(:industry)
        industry2  = FactoryGirl.create(:industry)
        efi        = FactoryGirl.create(:efi, industry_ids: [industry1.id])

        experience.industry_experiences.destroy_all
        FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry1.id, percentage: 99.0)
        FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry2.id, percentage: 1.0)
        experience.reload

        event = FactoryGirl.create(:event, efi_id: efi.id, exclusivity_id: Exclusivity.by_industry_id, experience_id: experience.id)

        FactoryGirl.build(:event,  exclusivity_id: Exclusivity.without_id, experience_id: experience.id, swaps: 99).should_not be_valid
        FactoryGirl.build(:event,  exclusivity_id: Exclusivity.without_id, experience_id: experience.id, swaps: 100).should_not be_valid
        FactoryGirl.build(:event,  exclusivity_id: Exclusivity.without_id, experience_id: experience.id, swaps: 101).should_not be_valid

        FactoryGirl.build(:event,  exclusivity_id: Exclusivity.without_id, experience_id: experience.id, swaps: experience.minimum_without_swaps).should_not be_valid

        FactoryGirl.build(:event,  exclusivity_id: Exclusivity.without_id,  experience_id: experience.id, swaps: experience.swaps - event.quantity).should be_valid
      end
    end

    it "debe requerir un swaps que sea entero" do
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.without_id, swaps: 1.5).should_not be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.without_id, swaps: '1.5').should_not be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.without_id, swaps: -1.5).should_not be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.without_id, swaps: '-1.5').should_not be_valid
    end
  end

  context "cuando se trata de un evento con 'exclusividad por industria'" do
    it "no debe requerir un swaps" do
      experience = FactoryGirl.create(:experience, total_exclusivity_sales: false)
      industry   = experience.industry_experiences.first.industry
      efi        = FactoryGirl.create(:efi, industry_ids: [industry.id])

      FactoryGirl.build(:event, efi_id: efi.id, experience_id: experience.id, exclusivity_id: Exclusivity.by_industry_id, swaps: nil).should be_valid
      FactoryGirl.build(:event, efi_id: efi.id, experience_id: experience.id, exclusivity_id: Exclusivity.by_industry_id, swaps: '').should be_valid
    end

    it "debe setear por defecto el quantity" do
      experience = FactoryGirl.create(:experience, total_exclusivity_sales: false)
      industry   = experience.industry_experiences.first.industry
      efi        = FactoryGirl.create(:efi, industry_ids: [industry.id])

      FactoryGirl.build(:event, efi_id: efi.id, experience_id: experience.id, exclusivity_id: Exclusivity.by_industry_id, quantity: nil).should be_valid
      FactoryGirl.build(:event, efi_id: efi.id, experience_id: experience.id, exclusivity_id: Exclusivity.by_industry_id, quantity: '').should be_valid
    end

    context "cuando no hay empresas participando de la experience" do
      it "debe requerir un quantity inferior al total de la experience" do
        experience = FactoryGirl.create(:experience, swaps: 30, codes: [], codes_by_purchase: nil)
        FactoryGirl.build(:event, experience_id: experience.id, exclusivity_id: Exclusivity.by_industry_id, quantity: 31).should_not be_valid
      end

      it "debe requerir un quantity segun porcentaje por industria" do
        industry1  = FactoryGirl.create(:industry)
        industry2  = FactoryGirl.create(:industry)
        experience = FactoryGirl.create(:experience, swaps: 30, codes: [], codes_by_purchase: nil, total_exclusivity_sales: false)
        efi        = FactoryGirl.create(:efi, industry_ids: [industry1.id])

        experience.industry_experiences.destroy_all
        FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry1.id, percentage: 50.0)
        FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry2.id, percentage: 50.0)
        experience.reload

        ([*1..experience.swaps] - [experience.industry_swaps(efi)]).each do |i|
          FactoryGirl.build(:event, efi_id: efi.id, experience_id: experience.id, exclusivity_id: Exclusivity.by_industry_id, quantity: i).should_not be_valid
        end

        FactoryGirl.build(:event, efi_id: efi.id, experience_id: experience.id, exclusivity_id: Exclusivity.by_industry_id, quantity: experience.industry_swaps(efi).to_s).should be_valid
        FactoryGirl.build(:event, efi_id: efi.id, experience_id: experience.id, exclusivity_id: Exclusivity.by_industry_id, quantity: experience.industry_swaps(efi)).should be_valid
      end
    end

    context "cuando ya tomaron la exclusividad total" do
      it "no debe permitir nuevos eventos" do
        industry1  = FactoryGirl.create(:industry)
        industry2  = FactoryGirl.create(:industry)
        experience = FactoryGirl.create(:experience, swaps: 30, codes: [], codes_by_purchase: nil)

        experience.industry_experiences.destroy_all
        FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry1.id, percentage: 50.0)
        FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry2.id, percentage: 50.0)
        experience.reload

        FactoryGirl.create(:event, exclusivity_id: Exclusivity.total_id, experience_id: experience.id)
        FactoryGirl.build(:event,  exclusivity_id: Exclusivity.by_industry_id, experience_id: experience.id).should_not be_valid
      end
    end

    context "cuando ya tomaron la exclusividad por industria" do
      it "no debe permitir nuevos eventos si pertenecen a la misma industria del la EFI del evento pre-existente" do
        industry1  = FactoryGirl.create(:industry)
        industry2  = FactoryGirl.create(:industry)
        efi1       = FactoryGirl.create(:efi, industry_ids: [industry1.id])
        efi2       = FactoryGirl.create(:efi, industry_ids: [industry1.id])
        experience = FactoryGirl.create(:experience, available_efi_ids: [efi1.id, efi2.id], total_exclusivity_sales: false)

        experience.industry_experiences.destroy_all
        FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry1.id, percentage: 50.0)
        FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry2.id, percentage: 50.0)
        experience.reload

        FactoryGirl.create(:event, exclusivity_id: Exclusivity.by_industry_id, experience_id: experience.id, efi_id: efi1.id)
        FactoryGirl.build(:event,  exclusivity_id: Exclusivity.by_industry_id, experience_id: experience.id, efi_id: efi2.id).should_not be_valid
      end
      it "debe permitir eventos de EFI's de industria distinta a la de la EFI del evento pre-existente" do
        industry1  = FactoryGirl.create(:industry)
        industry2  = FactoryGirl.create(:industry)
        efi1       = FactoryGirl.create(:efi, industry_ids: [industry1.id])
        efi2       = FactoryGirl.create(:efi, industry_ids: [industry2.id])
        experience = FactoryGirl.create(:experience, available_efi_ids: [efi1.id, efi2.id], total_exclusivity_sales: false)

        experience.industry_experiences.destroy_all
        FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry1.id, percentage: 50.0)
        FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry2.id, percentage: 50.0)
        experience.reload

        FactoryGirl.create(:event, efi_id: efi1.id, exclusivity_id: Exclusivity.by_industry_id, experience_id: experience.id)
        FactoryGirl.build(:event,  efi_id: efi2.id, exclusivity_id: Exclusivity.by_industry_id, experience_id: experience.id).should be_valid
      end
    end

    it "debe requerir un quantity numerico" do
      subject.stub(:exclusivity_id){Exclusivity.by_industry_id}
      should validate_numericality_of :quantity

      FactoryGirl.build(:event, exclusivity_id: Exclusivity.by_industry_id, quantity: 'a').should_not be_valid
    end

    it "debe requerir un quantity mayor a 0" do
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.by_industry_id, quantity: '-1').should_not be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.by_industry_id, quantity: -1).should_not be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.by_industry_id, quantity: '0').should_not be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.by_industry_id, quantity: 0).should_not be_valid
    end

    it "debe requerir un quantity que sea entero" do
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.by_industry_id, quantity: 1.5).should_not be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.by_industry_id, quantity: '1.5').should_not be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.by_industry_id, quantity: -1.5).should_not be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.by_industry_id, quantity: '-1.5').should_not be_valid
    end
  end

  context "cuando se trata de un evento con 'exclusividad total'" do
    it "no debe requerir un swaps" do
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id, swaps: nil).should be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id, swaps: '').should be_valid
    end

    it "debe setear por defecto el quantity" do
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id, quantity: nil).should be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id, quantity: '').should be_valid
    end

    it "debe requerir un quantity numerico" do
      subject.stub(:exclusivity_id){Exclusivity.total_id}
      should validate_numericality_of :quantity

      FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id, quantity: 'a').should_not be_valid
    end

    it "debe requerir un quantity mayor a 0" do
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id, quantity: '-1').should_not be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id, quantity: -1).should_not be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id, quantity: '0').should_not be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id, quantity: 0).should_not be_valid
    end

    it "debe requerir un quantity que sea entero" do
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id, quantity: 1.5).should_not be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id, quantity: '1.5').should_not be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id, quantity: -1.5).should_not be_valid
      FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id, quantity: '-1.5').should_not be_valid
    end

    context "cuando no hay empresas participando de la experience" do
      it "debe requerir un quantity igual a la cantidad total de swaps de la experiencia" do
        experience = FactoryGirl.create(:experience, swaps: 10)
        FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id, quantity: 5).should_not be_valid
        FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id, quantity: 10).should be_valid
      end
    end

    context "cuando hay empresas participando de la experience" do
      it "no debe permitir nuevos eventos si alguien tomo la experience sin exclusividad" do
        experience = FactoryGirl.create(:experience, swaps: 30, codes: [], codes_by_purchase: nil)
        experience.starting_at = Date.today - 4.days
        experience.save validate: false

        FactoryGirl.create(:event, exclusivity_id: Exclusivity.without_id, experience_id: experience.id, swaps: experience.minimum_without_swaps)
        FactoryGirl.build(:event,  exclusivity_id: Exclusivity.total_id,   experience_id: experience.id).should_not be_valid
      end
      it "no debe permitir nuevos eventos si alguien tomo la experience con exclusividad por industria" do
        experience = FactoryGirl.create(:experience, swaps: 30, codes: [], codes_by_purchase: nil)
        experience.starting_at = Date.today - 4.days
        experience.save validate: false

        industry   = experience.industry_experiences.first.industry
        efi        = FactoryGirl.create(:efi, industry_ids: [industry.id])

        FactoryGirl.create(:event, exclusivity_id: Exclusivity.by_industry_id, efi_id: efi.id, experience_id: experience.id)
        FactoryGirl.build(:event,  exclusivity_id: Exclusivity.total_id,       efi_id: efi.id, experience_id: experience.id).should_not be_valid
      end
      it "no debe permitir nuevos eventos si alguien tomo la experience con exclusividad total" do
        experience = FactoryGirl.create(:experience, swaps: 30, codes: [], codes_by_purchase: nil)
        FactoryGirl.create(:event, exclusivity_id: Exclusivity.total_id, experience_id: experience.id)
        FactoryGirl.build(:event,  exclusivity_id: Exclusivity.total_id, experience_id: experience.id).should_not be_valid
      end
    end
  end

  context "durante la creación" do
    describe "debe validar que la EFI pueda acceder a la Experience" do
      it "cuando la EFI tiene acceso debe ser valido" do
        efi        = FactoryGirl.create(:efi)
        experience = FactoryGirl.create(:experience, available_efi_ids: [efi.id])

        FactoryGirl.build(:event, efi_id: efi.id, experience_id: experience.id).should be_valid
      end

      it "cuando la EFI no tiene acceso no debe ser valido" do
        efi        = FactoryGirl.create(:efi)
        experience = FactoryGirl.create(:experience)

        event = FactoryGirl.build(:event, efi_id: efi.id, experience_id: experience.id)

        experience.experience_efis.destroy_all
        experience.available_efis.should be_empty
        event.should_not be_valid
      end
    end
  end

  context "durante la actualización" do
    it "no debe validar que la EFI siga pudiendo acceder a la Experience" do
      event = FactoryGirl.create(:event)
      event.experience.experience_efis.destroy_all

      event.experience.available_efis.should be_empty
      event.should be_valid
    end
  end

  context "cuando es el primer evento en la experience" do
    it 'despues de crear el event debe cambiar la experience a on_sale' do
      experience = FactoryGirl.create(:experience)
      experience.published?.should be_true

      FactoryGirl.create(:event, experience_id: experience.id)
      experience.reload
      experience.on_sale?.should be_true
    end
  end

  context "cuando no es el primer evento en la experience" do
    it 'despues de crear el event el state de la experience debe ser on_sale' do
      experience = FactoryGirl.create(:experience, total_exclusivity_sales: false, by_industry_exclusivity_sales: false)
      experience.published?.should be_true

      FactoryGirl.create(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id, swaps: experience.minimum_without_swaps)
      experience.reload
      experience.on_sale?.should be_true

      FactoryGirl.create(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id, swaps: experience.minimum_without_swaps)
      experience.reload
      experience.on_sale?.should be_true
    end
  end

  ###########
  # methods #
  ###########
  describe "para revisar el stock del evento" do
    it "debe responder a :check_stock!" do
      should respond_to :check_stock!
    end

    it "debe setear/des-setear la fecha en que se acabo el stock" do
      experience = FactoryGirl.create(:experience, total_exclusivity_sales: false,
                                                    by_industry_exclusivity_sales: false,
                                                    without_exclusivity_sales: true)

      event      = FactoryGirl.create(:event, experience_id: experience.id,
                                              exclusivity_id: Exclusivity.without_id,
                                              swaps: 1)
      exchange   = event.exchanges.last

      event.sold_at.should be_nil

      purchase = FactoryGirl.create(:purchase, exchange_id: exchange.id)

      event.reload
      event.sold_at.should_not be_nil

      purchase.redeem!

      event.reload
      event.sold_at.should be_nil
    end
  end

  describe 'para filtrar Events' do
    it "deberia responder a total_exclusivity" do
      Event.should respond_to :total_exclusivity
    end

    it "deberia responder a exclusivity_by_industry" do
      Event.should respond_to :exclusivity_by_industry
    end

    it "deberia responder a without_exclusivity" do
      Event.should respond_to :without_exclusivity
    end
  end

  describe 'experience_swaps' do
    it "deberia responder a exclusivity_name" do
      should respond_to :exclusivity_name
    end
  end

  describe 'experience_state' do
    it "deberia responder a experience_state" do
      should respond_to :experience_state
    end
  end

  describe 'experience_name' do
    it "deberia responder a experience_name" do
      should respond_to :experience_name
    end
  end

  describe 'efi_logo' do
    it "deberia responder a efi_logo" do
      should respond_to :efi_logo
    end
  end

  describe 'efi_name' do
    it "deberia responder a efi_name" do
      should respond_to :efi_name
    end
  end

  describe 'exclusivity' do
    it "deberia responder a exclusivity" do
      should respond_to :exclusivity
    end
  end

  describe 'exclusivity_name' do
    it "deberia responder a exclusivity_name" do
      should respond_to :exclusivity_name
    end
  end

  it "debe redefinir el metodo to_s" do
    should respond_to :to_s
    event = FactoryGirl.create(:event)
    event.to_s.should eq(event.experience.name)
  end

  describe "exclusivity questions" do
    describe "total_exclusivity?" do
      it "debe responder a total_exclusivity?" do
        should respond_to :total_exclusivity?
      end
      it "debe responder TRUE" do
        event = FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id)
        event.total_exclusivity?.should be_true
      end
      it "debe responder FALSE" do
        event = FactoryGirl.build(:event, exclusivity_id: Exclusivity.by_industry_id)
        event.total_exclusivity?.should be_false
      end
      it "debe responder FALSE" do
        event = FactoryGirl.build(:event, exclusivity_id: Exclusivity.without_id)
        event.total_exclusivity?.should be_false
      end
    end

    describe "by_industry_exclusivity?" do
      it "debe responder a by_industry_exclusivity?" do
        should respond_to :by_industry_exclusivity?
      end
      it "debe responder FALSE" do
        event = FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id)
        event.by_industry_exclusivity?.should be_false
      end
      it "debe responder TRUE" do
        event = FactoryGirl.build(:event, exclusivity_id: Exclusivity.by_industry_id)
        event.by_industry_exclusivity?.should be_true
      end
      it "debe responder FALSE" do
        event = FactoryGirl.build(:event, exclusivity_id: Exclusivity.without_id)
        event.by_industry_exclusivity?.should be_false
      end
    end

    describe "without_exclusivity?" do
      it "debe responder a without_exclusivity?" do
        should respond_to :without_exclusivity?
      end
      it "debe responder FALSE" do
        event = FactoryGirl.build(:event, exclusivity_id: Exclusivity.total_id)
        event.without_exclusivity?.should be_false
      end
      it "debe responder FALSE" do
        event = FactoryGirl.build(:event, exclusivity_id: Exclusivity.by_industry_id)
        event.without_exclusivity?.should be_false
      end
      it "debe responder TRUE" do
        event = FactoryGirl.build(:event, exclusivity_id: Exclusivity.without_id)
        event.without_exclusivity?.should be_true
      end
    end
  end

  describe 'para filtrar Events' do
    it "debe responder a are_taken" do
      Event.should respond_to :are_taken
    end

    it "debe responder a are_taken_or_published" do
      Event.should respond_to :are_taken_or_published
    end

    it "debe responder a are_published" do
      Event.should respond_to :are_published
    end

    it "debe responder a are_closed" do
      Event.should respond_to :are_closed
    end

    it "debe responder a are_billed" do
      Event.should respond_to :are_billed
    end

    it "debe responder a are_paid" do
      Event.should respond_to :are_paid
    end

    it "debe responder a started" do
      Event.should respond_to :started
    end
  end

  describe 'swaps_or_quantity' do
    it 'debe responder a swaps_or_quantity' do
      should respond_to :swaps_or_quantity
    end

    it 'debe responder con un valor apropiado' do
      event1 = FactoryGirl.create(:event, exclusivity_id: Exclusivity.total_id)
      event1.swaps_or_quantity.should eq(event1.quantity)


      experience = FactoryGirl.create(:experience, swaps: 10, total_exclusivity_sales: false)
      efi        = FactoryGirl.create(:efi)
      efi.industries << experience.industry_experiences.first.industry
      efi.reload
      event2       = FactoryGirl.create(:event, experience_id: experience.id, efi_id: efi.id, exclusivity_id: Exclusivity.by_industry_id)
      event2.swaps_or_quantity.should eq(event2.quantity)


      experience = FactoryGirl.create(:experience, total_exclusivity_sales: false, by_industry_exclusivity_sales: false)
      event3 = FactoryGirl.create(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id, swaps: 5)
      event3.swaps_or_quantity.should eq(event3.swaps)
    end
  end

  context 'para obtener el estado en que se encuentra el evento' do
    it "debe responder a translate_state" do
      should respond_to :translate_state
    end

    it "debe responder con una traducción legible" do
      event = FactoryGirl.create(:event)
      ['taken', 'published', 'closed', 'billed', 'paid'].each do |s|
        event.state = s
        event.translate_state.include?('translation missing:').should be_false
      end

      event.state = 'estado_no_existente'
      event.translate_state.include?('translation missing:').should be_false
      event.translate_state.should eq('estado_no_existente')
    end
  end

  context 'para si el evento se encuentra en algun(os) estado(s) en particular' do
    it "debe responder a in_state?" do
      should respond_to :in_state?
    end

    it "debe responder con un valor valido" do
      event = FactoryGirl.create(:event, state: 'published')
      event.in_state?(['published']).should be_true
      event.in_state?('published').should be_true
      event.in_state?(:published).should be_true
      event.in_state?(['taken', 'published', 'closed', 'billed', 'paid']).should be_true
      event.in_state?([:taken, :published, :closed, :billed, :paid]).should be_true

      event.in_state?(['taken', 'closed', 'billed', 'paid']).should be_false
      event.in_state?('alfa').should be_false
      event.in_state?(:alfa).should be_false
      event.in_state?(1).should be_nil
      event.in_state?(nil).should be_nil
    end
  end

  #################
  # state_machine #
  #################
  describe "state_machine" do
    context "states" do
      it "debe tener estados" do
        FactoryGirl.create(:event, state: 'taken').should be_valid
        FactoryGirl.create(:event, state: 'closed').should be_valid
        FactoryGirl.create(:event, state: 'billed').should be_valid
        FactoryGirl.create(:event, state: 'paid').should be_valid
        FactoryGirl.create(:event, state: 'published').should be_valid

        expect {
          FactoryGirl.create(:event, state: 'otro_estado_no_valido')
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "events" do
      describe "unpublish!" do
        it "debe cambiar el estado" do
          event = FactoryGirl.create(:event, state: 'published')
          event.unpublish!.should be_true
          event.taken?.should be_true
        end

        it "no debe cambiar el estado" do
          ['taken', 'closed', 'billed', 'paid'].each do |s|
            event = FactoryGirl.create(:event, state: s)
            event.unpublish!.should be_false
          end
        end
      end

      describe "publish!" do
        it "debe cambiar el estado" do
          event = FactoryGirl.create(:event, state: 'taken')
          event.publish!.should be_true
          event.published?.should be_true
        end

        it "no debe cambiar el estado" do
          ['published', 'closed', 'billed', 'paid'].each do |s|
            event = FactoryGirl.create(:event, state: s)
            event.publish!.should be_false
          end
        end
      end

      describe "close!" do
        it "debe cambiar el estado cuando esta en :taken" do
          event = FactoryGirl.create(:event, state: 'taken')
          event.close!.should be_true
          event.closed?.should be_true
        end
        it "debe cambiar el estado cuando esta en :published" do
          event = FactoryGirl.create(:event, state: 'published')
          event.close!.should be_true
          event.closed?.should be_true
        end

        it "no debe cambiar el estado" do
          ['closed', 'billed', 'paid'].each do |s|
            event = FactoryGirl.create(:event, state: s)
            event.close!.should be_false
          end
        end
      end

      describe "bill!" do
        it "debe cambiar el estado" do
          event = FactoryGirl.create(:event, state: 'closed')
          event.bill!.should be_true
          event.billed?.should be_true
        end

        it "no debe cambiar el estado" do
          ['taken', 'published', 'billed', 'paid'].each do |s|
            event = FactoryGirl.create(:event, state: s)
            event.bill!.should be_false
          end
        end
      end

      describe "pay!" do
        it "debe cambiar el estado" do
          event = FactoryGirl.create(:event, state: 'billed')
          event.billed?.should be_true
          event.pay!.should be_true
          event.paid?.should be_true
        end

        it "no debe cambiar el estado" do
          ['taken', 'published', 'closed', 'paid'].each do |s|
            event = FactoryGirl.create(:event, state: s)
            event.pay!.should be_false
          end
        end
      end
    end

    context "transitions" do
    end
  end
end
