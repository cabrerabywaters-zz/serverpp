# encoding: utf-8
require 'spec_helper'

describe Experience do
  ##############
  # attributes #
  ##############
  describe "attributes" do
    it "debe responder a amount" do
      should respond_to :amount
    end

    it "debe responder a available_efi_ids" do
      should respond_to :available_efi_ids
    end

    it "debe responder a category_id" do
      should respond_to :category_id
    end

    it "debe responder a details" do
      should respond_to :details
    end

    it "debe responder a eco_id" do
      should respond_to :eco_id
    end

    it "debe responder a ending_at" do
      should respond_to :ending_at
    end

    it "debe responder a interest_ids" do
      should respond_to :interest_ids
    end

    it "debe responder a image" do
      should respond_to :image
    end

    it "debe responder a name" do
      should respond_to :name
    end

    it "debe responder a place" do
      should respond_to :place
    end

    it "debe responder a starting_at" do
      should respond_to :starting_at
    end

    it "debe responder a summary" do
      should respond_to :summary
    end

    it "debe responder a swaps" do
      should respond_to :swaps
    end

    it "debe responder a validity_ending_at" do
      should respond_to :validity_ending_at
    end

    it "debe responder a validity_starting_at" do
      should respond_to :validity_starting_at
    end

    it "debe responder a discounted_price" do
      should respond_to :discounted_price
    end

    it "debe responder a discount_percentage" do
      should respond_to :discount_percentage
    end

    it "debe responder a codes" do
      should respond_to :codes
    end

    it "debe responder a file_codes" do
      should respond_to :file_codes
    end

    # it "debe responder a chilean_cities_comuna_id" do
    #   should respond_to :chilean_cities_comuna_id
    # end

    it "debe responder a validated" do
      should respond_to :validated
    end

    it "debe responder a state" do
      should respond_to :state
    end

    it "debe responder a conditions" do
      should respond_to :conditions
    end

    it "debe responder a exchange_mechanism" do
      should respond_to :exchange_mechanism
    end

    it "debe responder a codes_by_purchase" do
      should respond_to :codes_by_purchase
    end

    it "debe responder a fee" do
      should respond_to :fee
    end

    it "debe responder a total_exclusivity_sales" do
      should respond_to :total_exclusivity_sales
    end

    it "debe responder a by_industry_exclusivity_sales" do
      should respond_to :by_industry_exclusivity_sales
    end

    it "debe responder a without_exclusivity_sales" do
      should respond_to :without_exclusivity_sales
    end

    it "debe responder a total_exclusivity_days" do
      should respond_to :total_exclusivity_days
    end

    it "debe responder a by_industry_exclusivity_days" do
      should respond_to :by_industry_exclusivity_days
    end
  end

  ################
  # associations #
  ################
  describe "associations" do
    it "debe pertenecer a category" do
      should belong_to(:category)
    end

    it "debe pertenecer a eco" do
      should belong_to(:eco)
    end
    # it "debe pertenecer a comuna" do
    #   should belong_to(:comuna)
    # end

    it "debe tener muchos experience_efis" do
      should have_many(:experience_efis).dependent(:destroy)
    end

    it "debe tener muchos efis" do
      should have_many(:available_efis).through(:experience_efis)#.source(:efi)
    end

    it "debe tener muchos experience_advertisings" do
      should have_many(:experience_advertisings).dependent(:destroy)
    end

    it "debe tener muchos advertisings" do
      should have_many(:advertisings).through(:experience_advertisings)
    end

    it "debe tener muchos interest_experiences" do
      should have_many(:interest_experiences).dependent(:destroy)
    end

    it "debe tener muchos interests" do
      should have_many(:interests).through(:interest_experiences)
    end

    it "debe tener muchos events" do
      should have_many(:events).dependent(:destroy)
    end

    it "debe tener muchos industry_experiences" do
      should have_many(:industry_experiences).dependent(:destroy)
    end

    it "debe tener muchos valid_images" do
      should have_many(:valid_images).dependent(:destroy)
    end
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:experience).should be_valid
  end

  describe ":total_exclusivity_days validations" do
    context "con :by_industry_exclusivity_sales y :without_exclusivity_sales" do
      it "debe requerir un :total_exclusivity_days numerico" do
        subject.stub(:state){'published'}
        subject.stub(:by_industry_exclusivity_sales){true}
        subject.stub(:without_exclusivity_sales){true}
        should validate_numericality_of(:total_exclusivity_days).only_integer

        FactoryGirl.build(:experience, total_exclusivity_days: 'a', by_industry_exclusivity_sales: true, without_exclusivity_sales: true).should_not be_valid
      end

      it "debe requerir un :total_exclusivity_days mayor o igual que cero" do
        FactoryGirl.build(:experience, total_exclusivity_days: '-1',   by_industry_exclusivity_sales: true, without_exclusivity_sales: true).should_not be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  -1,    by_industry_exclusivity_sales: true, without_exclusivity_sales: true).should_not be_valid
        FactoryGirl.build(:experience, total_exclusivity_days: '-1.5', by_industry_exclusivity_sales: true, without_exclusivity_sales: true).should_not be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  -1.5,  by_industry_exclusivity_sales: true, without_exclusivity_sales: true).should_not be_valid

        FactoryGirl.build(:experience, total_exclusivity_days: '0',    by_industry_exclusivity_sales: true, without_exclusivity_sales: true).should be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  0,     by_industry_exclusivity_sales: true, without_exclusivity_sales: true).should be_valid
      end

      it "debe estar presente" do
        FactoryGirl.build(:experience, total_exclusivity_days:  1,   total_exclusivity_sales: true,  by_industry_exclusivity_sales: true, without_exclusivity_sales: true).should be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  nil, total_exclusivity_sales: false, by_industry_exclusivity_sales: true, without_exclusivity_sales: true).should be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  '',  total_exclusivity_sales: false, by_industry_exclusivity_sales: true, without_exclusivity_sales: true).should be_valid

        FactoryGirl.build(:experience, total_exclusivity_days:  nil, total_exclusivity_sales: true, by_industry_exclusivity_sales: true, without_exclusivity_sales: true).should_not be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  '',  total_exclusivity_sales: true, by_industry_exclusivity_sales: true, without_exclusivity_sales: true).should_not be_valid
      end
    end

    context "con :by_industry_exclusivity_sales" do
      it "debe requerir un :total_exclusivity_days numerico" do
        subject.stub(:state){'published'}
        subject.stub(:by_industry_exclusivity_sales){true}
        should validate_numericality_of(:total_exclusivity_days).only_integer

        FactoryGirl.build(:experience, total_exclusivity_days: 'a', by_industry_exclusivity_sales: true, without_exclusivity_sales: false).should_not be_valid
      end

      it "debe requerir un :total_exclusivity_days mayor o igual que cero" do
        FactoryGirl.build(:experience, total_exclusivity_days: '-1',   by_industry_exclusivity_sales: true, without_exclusivity_sales: false).should_not be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  -1,    by_industry_exclusivity_sales: true, without_exclusivity_sales: false).should_not be_valid
        FactoryGirl.build(:experience, total_exclusivity_days: '-1.5', by_industry_exclusivity_sales: true, without_exclusivity_sales: false).should_not be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  -1.5,  by_industry_exclusivity_sales: true, without_exclusivity_sales: false).should_not be_valid

        FactoryGirl.build(:experience, total_exclusivity_days: '0',    by_industry_exclusivity_sales: true, without_exclusivity_sales: false).should be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  0,     by_industry_exclusivity_sales: true, without_exclusivity_sales: false).should be_valid
      end

      it "debe estar presente" do
        FactoryGirl.build(:experience, total_exclusivity_days:  1,   total_exclusivity_sales: true,  by_industry_exclusivity_sales: true, without_exclusivity_sales: false).should be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  nil, total_exclusivity_sales: false, by_industry_exclusivity_sales: true, without_exclusivity_sales: false).should be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  '',  total_exclusivity_sales: false, by_industry_exclusivity_sales: true, without_exclusivity_sales: false).should be_valid

        FactoryGirl.build(:experience, total_exclusivity_days:  nil, total_exclusivity_sales: true, by_industry_exclusivity_sales: true, without_exclusivity_sales: false).should_not be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  '',  total_exclusivity_sales: true, by_industry_exclusivity_sales: true, without_exclusivity_sales: false).should_not be_valid
      end
    end

    context "con :without_exclusivity_sales" do
      it "debe requerir un :total_exclusivity_days numerico" do
        subject.stub(:state){'published'}
        subject.stub(:without_exclusivity_sales){true}
        should validate_numericality_of(:total_exclusivity_days).only_integer

        FactoryGirl.build(:experience, total_exclusivity_days: 'a', by_industry_exclusivity_sales: false, without_exclusivity_sales: true).should_not be_valid
      end

      it "debe requerir un :total_exclusivity_days mayor o igual que cero" do
        FactoryGirl.build(:experience, total_exclusivity_days: '-1',   by_industry_exclusivity_sales: false, without_exclusivity_sales: true).should_not be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  -1,    by_industry_exclusivity_sales: false, without_exclusivity_sales: true).should_not be_valid
        FactoryGirl.build(:experience, total_exclusivity_days: '-1.5', by_industry_exclusivity_sales: false, without_exclusivity_sales: true).should_not be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  -1.5,  by_industry_exclusivity_sales: false, without_exclusivity_sales: true).should_not be_valid

        FactoryGirl.build(:experience, total_exclusivity_days: '0',    by_industry_exclusivity_sales: false, without_exclusivity_sales: true).should be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  0,     by_industry_exclusivity_sales: false, without_exclusivity_sales: true).should be_valid
      end

      it "debe estar presente" do
        FactoryGirl.build(:experience, total_exclusivity_days:  1,   total_exclusivity_sales: true,  by_industry_exclusivity_sales: false, without_exclusivity_sales: true).should be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  nil, total_exclusivity_sales: false, by_industry_exclusivity_sales: false, without_exclusivity_sales: true).should be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  '',  total_exclusivity_sales: false, by_industry_exclusivity_sales: false, without_exclusivity_sales: true).should be_valid

        FactoryGirl.build(:experience, total_exclusivity_days:  nil, total_exclusivity_sales: true, by_industry_exclusivity_sales: false, without_exclusivity_sales: true).should_not be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  '',  total_exclusivity_sales: true, by_industry_exclusivity_sales: false, without_exclusivity_sales: true).should_not be_valid
      end
    end

    context "sin :by_industry_exclusivity_sales y :without_exclusivity_sales" do
      it "debe requerir un :total_exclusivity_days numerico" do
        FactoryGirl.build(:experience, total_exclusivity_days: 'a', by_industry_exclusivity_sales: false, without_exclusivity_sales: false).should_not be_valid
        FactoryGirl.build(:experience, total_exclusivity_days: nil, by_industry_exclusivity_sales: false, without_exclusivity_sales: false).should     be_valid
      end

      it "debe requerir un :total_exclusivity_days mayor o igual que cero" do
        FactoryGirl.build(:experience, total_exclusivity_days: '-1',   by_industry_exclusivity_sales: false, without_exclusivity_sales: false).should_not be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  -1,    by_industry_exclusivity_sales: false, without_exclusivity_sales: false).should_not be_valid
        FactoryGirl.build(:experience, total_exclusivity_days: '-1.5', by_industry_exclusivity_sales: false, without_exclusivity_sales: false).should_not be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  -1.5,  by_industry_exclusivity_sales: false, without_exclusivity_sales: false).should_not be_valid

        FactoryGirl.build(:experience, total_exclusivity_days: '0',    by_industry_exclusivity_sales: false, without_exclusivity_sales: false).should be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  0,     by_industry_exclusivity_sales: false, without_exclusivity_sales: false).should be_valid
      end

      it "debe estar presente" do
        FactoryGirl.build(:experience, total_exclusivity_days:  1,   total_exclusivity_sales: true, by_industry_exclusivity_sales: false, without_exclusivity_sales: false).should be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  nil, total_exclusivity_sales: true, by_industry_exclusivity_sales: false, without_exclusivity_sales: false).should be_valid
        FactoryGirl.build(:experience, total_exclusivity_days:  '',  total_exclusivity_sales: true, by_industry_exclusivity_sales: false, without_exclusivity_sales: false).should be_valid
      end
    end
  end

  describe ":by_industry_exclusivity_days validations" do
    context "con :without_exclusivity_sales" do
      it "debe requerir un :by_industry_exclusivity_days numerico" do
        subject.stub(:state){'published'}
        subject.stub(:without_exclusivity_sales){true}
        should validate_numericality_of(:by_industry_exclusivity_days).only_integer

        FactoryGirl.build(:experience, by_industry_exclusivity_days: 'a', without_exclusivity_sales: true).should_not be_valid
      end

      it "debe requerir un :by_industry_exclusivity_days mayor o igual que cero" do
        FactoryGirl.build(:experience, by_industry_exclusivity_days: '-1',   without_exclusivity_sales: true).should_not be_valid
        FactoryGirl.build(:experience, by_industry_exclusivity_days:  -1,    without_exclusivity_sales: true).should_not be_valid
        FactoryGirl.build(:experience, by_industry_exclusivity_days: '-1.5', without_exclusivity_sales: true).should_not be_valid
        FactoryGirl.build(:experience, by_industry_exclusivity_days:  -1.5,  without_exclusivity_sales: true).should_not be_valid

        # FactoryGirl.build(:experience, by_industry_exclusivity_days: '0',    without_exclusivity_sales: true).should be_valid
        # FactoryGirl.build(:experience, by_industry_exclusivity_days:  0,     without_exclusivity_sales: true).should be_valid
      end

      it "debe estar presente" do
        FactoryGirl.build(:experience, by_industry_exclusivity_days:  1,   by_industry_exclusivity_sales: true,  without_exclusivity_sales: true).should be_valid
        FactoryGirl.build(:experience, by_industry_exclusivity_days:  nil, by_industry_exclusivity_sales: false, without_exclusivity_sales: true).should be_valid
        FactoryGirl.build(:experience, by_industry_exclusivity_days:  '',  by_industry_exclusivity_sales: false, without_exclusivity_sales: true).should be_valid

        FactoryGirl.build(:experience, by_industry_exclusivity_days:  nil, by_industry_exclusivity_sales: true, without_exclusivity_sales: true).should_not be_valid
        FactoryGirl.build(:experience, by_industry_exclusivity_days:  '',  by_industry_exclusivity_sales: true, without_exclusivity_sales: true).should_not be_valid
      end
    end

    context "sin :without_exclusivity_sales" do
      it "debe requerir un :by_industry_exclusivity_days numerico" do
        FactoryGirl.build(:experience, by_industry_exclusivity_days: 'a', without_exclusivity_sales: false).should_not be_valid
        FactoryGirl.build(:experience, by_industry_exclusivity_days: nil, without_exclusivity_sales: false).should     be_valid
      end

      it "debe requerir un :by_industry_exclusivity_days mayor o igual que cero" do
        FactoryGirl.build(:experience, by_industry_exclusivity_days: '-1',   without_exclusivity_sales: false).should_not be_valid
        FactoryGirl.build(:experience, by_industry_exclusivity_days:  -1,    without_exclusivity_sales: false).should_not be_valid
        FactoryGirl.build(:experience, by_industry_exclusivity_days: '-1.5', without_exclusivity_sales: false).should_not be_valid
        FactoryGirl.build(:experience, by_industry_exclusivity_days:  -1.5,  without_exclusivity_sales: false).should_not be_valid

        # FactoryGirl.build(:experience, by_industry_exclusivity_days: '0',    without_exclusivity_sales: false).should be_valid
        # FactoryGirl.build(:experience, by_industry_exclusivity_days:  0,     without_exclusivity_sales: false).should be_valid
      end

      it "debe estar presente" do
        FactoryGirl.build(:experience, by_industry_exclusivity_days:  1,   by_industry_exclusivity_sales: true, without_exclusivity_sales: false).should be_valid
        FactoryGirl.build(:experience, by_industry_exclusivity_days:  nil, by_industry_exclusivity_sales: true, without_exclusivity_sales: false).should be_valid
        FactoryGirl.build(:experience, by_industry_exclusivity_days:  '',  by_industry_exclusivity_sales: true, without_exclusivity_sales: false).should be_valid
      end
    end
  end

  describe ":fee validations" do
    it "debe requerir un :fee desde el step3 en adelante" do
      ['draft'].each do |s|
        subject.stub(:state){s}
        FactoryGirl.build(:experience, fee: nil, state: s).should be_valid
        FactoryGirl.build(:experience, fee: '',  state: s).should be_valid
      end

      ['published', 'active', 'closed', 'expired'].each do |s|
        subject.stub(:state){s}
        experience = FactoryGirl.build(:experience, fee: nil, state: s)
        experience.should_not be_valid
        experience.fee.should be_nil

        FactoryGirl.build(:experience, fee: '',  state: s).should_not be_valid
      end
    end

    it 'debe requerir un :fee segun comision negociada con ECO' do
      eco = FactoryGirl.create(:eco, fee: 20)

      FactoryGirl.build(:experience, eco_id: eco.id, fee: eco.fee).should be_valid
      FactoryGirl.build(:experience, eco_id: eco.id, fee: eco.fee + 1).should be_valid

      FactoryGirl.build(:experience, eco_id: eco.id, fee: eco.fee - 1).should_not be_valid
    end

    it "debe requerir un :fee mayor o igual que cero" do
      FactoryGirl.build(:experience, fee: '-1').should_not   be_valid
      FactoryGirl.build(:experience, fee:  -1).should_not    be_valid
      FactoryGirl.build(:experience, fee: '-1.5').should_not be_valid
      FactoryGirl.build(:experience, fee:  -1.5).should_not  be_valid
    end

    it "debe requerir un :fee menor que 100" do
      FactoryGirl.build(:experience, fee: '101').should_not   be_valid
      FactoryGirl.build(:experience, fee:  101).should_not    be_valid
      FactoryGirl.build(:experience, fee: '101.1').should_not be_valid
      FactoryGirl.build(:experience, fee:  101.1).should_not  be_valid
      FactoryGirl.build(:experience, fee:  '100').should_not  be_valid
      FactoryGirl.build(:experience, fee:  100).should_not    be_valid
    end
  end

  describe ":codes_by_purchase validations" do
    context "cuando se ingreso algun codigo" do
      it "debe requerir un :codes_by_purchase" do
        FactoryGirl.build(:experience, swaps: 1, codes: ['asdf'], codes_by_purchase: nil).should_not be_valid
        FactoryGirl.build(:experience, swaps: 1, codes: ['asdf'], codes_by_purchase: '' ).should_not be_valid
      end

      it "debe requerir un :codes_by_purchase numerico" do
        subject.stub(:codes){ ['asdf'] }
        should validate_numericality_of(:codes_by_purchase).only_integer

        FactoryGirl.build(:experience, swaps: 1, codes: ['asdf'], codes_by_purchase: 'a').should_not be_valid
      end

      it "debe requerir un :codes_by_purchase mayor que 0" do
        FactoryGirl.build(:experience, swaps: 1, codes: ['asdf'], codes_by_purchase: '-1').should_not be_valid
        FactoryGirl.build(:experience, swaps: 1, codes: ['asdf'], codes_by_purchase: -1).should_not be_valid
        FactoryGirl.build(:experience, swaps: 1, codes: ['asdf'], codes_by_purchase: '0').should_not be_valid
        FactoryGirl.build(:experience, swaps: 1, codes: ['asdf'], codes_by_purchase: 0).should_not be_valid

        FactoryGirl.build(:experience, swaps: 1, codes: ['asdf'], codes_by_purchase: '1').should be_valid
        FactoryGirl.build(:experience, swaps: 1, codes: ['asdf'], codes_by_purchase: 1).should be_valid
        FactoryGirl.build(:experience, swaps: 1, codes: ['asdf', 'qwerty'], codes_by_purchase: '2').should be_valid
        FactoryGirl.build(:experience, swaps: 1, codes: ['asdf', 'qwerty'], codes_by_purchase: 2).should be_valid
      end
    end
  end

  it "debe requerir un conditions" do
    FactoryGirl.build(:experience, conditions: nil).should_not be_valid
    FactoryGirl.build(:experience, conditions: '' ).should_not be_valid
  end

  it "debe requerir un exchange_mechanism" do
    FactoryGirl.build(:experience, exchange_mechanism: nil).should_not be_valid
    FactoryGirl.build(:experience, exchange_mechanism: '' ).should_not be_valid
  end

  it "debe requerir un category_id" do
    FactoryGirl.build(:experience, category_id: nil).should_not be_valid
    FactoryGirl.build(:experience, category_id: '').should_not be_valid
  end

  it "debe requerir un details" do
    FactoryGirl.build(:experience, details: nil).should_not be_valid
    FactoryGirl.build(:experience, details: '').should_not be_valid
  end

  it "debe requerir un eco_id" do
    FactoryGirl.build(:experience, eco_id: nil).should_not be_valid
    FactoryGirl.build(:experience, eco_id: '').should_not be_valid
  end

  it "debe requerir un ending_at" do
    FactoryGirl.build(:experience, ending_at: nil).should_not be_valid
    FactoryGirl.build(:experience, ending_at: '').should_not be_valid
  end

  describe ":name validations" do
    it "debe requerir un name" do
      FactoryGirl.build(:experience, name: nil).should_not be_valid
      FactoryGirl.build(:experience, name: '').should_not be_valid
    end

    context "cuando las otras experiencias no estan publicadas" do
      it "no debe requerir un name único" do
        ['draft', 'closed', 'expired'].each do |s|
          Experience.destroy_all
          FactoryGirl.create(:experience, name: 'Evento', state: s)
          FactoryGirl.build(:experience,  name: 'Evento').should be_valid
        end
      end
    end

    context "cuando las otras experiencias estan publicadas" do
      it "debe requerir un name único cuando esta published" do
        ['published', 'active'].each do |s|
          Experience.destroy_all
          FactoryGirl.create(:experience, name: 'Evento', state: :published)
          e=FactoryGirl.build(:experience,  name: 'Evento', state: s)
          e.should_not be_valid
        end
      end
    end

    context "cuando las otras experiencias estan publicadas pero sin stock" do
      it "debe requerir un name único cuando esta published" do
        Experience.destroy_all
        experience = FactoryGirl.create(:experience, name: 'Evento', swaps: 1, codes: ['asdf'])
        event      = FactoryGirl.create(:event, experience_id: experience.id)
        exchange   = event.exchanges.first
        FactoryGirl.create(:purchase, exchange_id: exchange.id)

        experience.in_state?(['published', 'active']).should be_true
        FactoryGirl.build(:experience,  name: 'Evento').should be_valid
      end
    end
  end

  # it "debe requerir un place" do
  #   FactoryGirl.build(:experience, place: nil).should_not be_valid
  #   FactoryGirl.build(:experience, place: '').should_not be_valid
  # end

  it "debe requerir un starting_at" do
    FactoryGirl.build(:experience, starting_at: nil).should_not be_valid
    FactoryGirl.build(:experience, starting_at: '').should_not be_valid
  end

  it "debe requerir un summary" do
    FactoryGirl.build(:experience, summary: nil).should_not be_valid
    FactoryGirl.build(:experience, summary: '').should_not be_valid
  end

  describe ":swaps validations" do
    it "debe requerir un swaps" do
      FactoryGirl.build(:experience, swaps: nil).should_not be_valid
      FactoryGirl.build(:experience, swaps: '').should_not be_valid
    end

    it "debe requerir un swaps numerico" do
      ['published', 'active'].each do |s|
        subject.stub(:state){s}
        should validate_numericality_of(:swaps).only_integer
        FactoryGirl.build(:experience, swaps: 'a').should_not be_valid
      end
    end

    it "debe requerir un swaps mayor que 0" do
      FactoryGirl.build(:experience, swaps: '-1', codes: [], codes_by_purchase: nil).should_not be_valid
      FactoryGirl.build(:experience, swaps: -1,   codes: [], codes_by_purchase: nil).should_not be_valid
      FactoryGirl.build(:experience, swaps: '0',  codes: [], codes_by_purchase: nil).should_not be_valid
      FactoryGirl.build(:experience, swaps: 0,    codes: [], codes_by_purchase: nil).should_not be_valid

      FactoryGirl.build(:experience, swaps: '1', codes: [], codes_by_purchase: nil).should be_valid
      FactoryGirl.build(:experience, swaps: 1,   codes: [], codes_by_purchase: nil).should be_valid
    end
  end

  it "debe requerir un validity_ending_at" do
    FactoryGirl.build(:experience, validity_ending_at: nil).should_not be_valid
    FactoryGirl.build(:experience, validity_ending_at: '').should_not be_valid
  end

  it "debe requerir un validity_starting_at" do
    FactoryGirl.build(:experience, validity_starting_at: nil).should_not be_valid
    FactoryGirl.build(:experience, validity_starting_at: '').should_not be_valid
  end

  # it "debe requerir un chilean_cities_comuna_id" do
  #   FactoryGirl.build(:experience, chilean_cities_comuna_id: nil).should_not be_valid
  #   FactoryGirl.build(:experience, chilean_cities_comuna_id: '').should_not  be_valid
  # end

  it "debe requerir un image" do
    ['published', 'active'].each do |s|
      subject.stub(:state){s}
      should validate_attachment_presence(:image)
    end
  end

  # it "debe validar el contenido del image" do
  #   should validate_attachment_content_type(:image).allowing('image/png', 'image/gif').rejecting('text/plain', 'text/xml')
  # end
  # it "debe validar el tamaño del image" do
  #   should validate_attachment_size(:image).less_than(2.megabytes)
  # end

  describe "amount" do
    it "debe requerir un amount" do
      FactoryGirl.build(:experience, amount: nil).should_not be_valid
      FactoryGirl.build(:experience, amount: '').should_not  be_valid
    end

    it "debe requerir un amount numerico" do
      ['published', 'active'].each do |s|
        subject.stub(:state){s}

        should validate_numericality_of(:amount).only_integer
        FactoryGirl.build(:experience, amount: 'a').should_not be_valid

        FactoryGirl.build(:experience, amount: '-1').should_not be_valid
        FactoryGirl.build(:experience, amount: -1).should_not be_valid
        FactoryGirl.build(:experience, amount: '0').should_not be_valid
        FactoryGirl.build(:experience, amount: 0).should_not be_valid
        FactoryGirl.build(:experience, amount: '-1.5').should_not be_valid
        FactoryGirl.build(:experience, amount: -1.5).should_not be_valid
        FactoryGirl.build(:experience, amount: '1.5').should_not be_valid
        FactoryGirl.build(:experience, amount: 1.5).should_not be_valid

        FactoryGirl.build(:experience, amount: '1').should be_valid
        FactoryGirl.build(:experience, amount: 1).should be_valid
      end
    end
  end



  describe "debe validar los rangos de la fechas" do
    context "al crear" do
      it "debe requerir un starting_at mayor a la fecha de hoy" do
        FactoryGirl.build(:experience,
                          starting_at:          Date.current,
                          validity_starting_at: Date.current,
                          ending_at:            Date.current,
                          validity_ending_at:   Date.current).should be_valid

        FactoryGirl.build(:experience,
                          starting_at:          (Date.current - 10.days),
                          validity_starting_at: (Date.current - 10.days),
                          ending_at:            (Date.current - 10.days),
                          validity_ending_at:   (Date.current - 10.days)).should_not be_valid

        FactoryGirl.build(:experience,
                          starting_at:          (Date.current - 1.days),
                          validity_starting_at: (Date.current - 10.days),
                          ending_at:            (Date.current - 10.days),
                          validity_ending_at:   (Date.current - 10.days)).should_not be_valid
      end
    end

    context "al actualizar" do
      it "debe requerir un starting_at mayor a la fecha de hoy" do
        experience = FactoryGirl.create(:experience,
                                        starting_at:          Date.current,
                                        validity_starting_at: Date.current,
                                        ending_at:            Date.current,
                                        validity_ending_at:   Date.current,
                                        created_at:           (Date.current - 5.days) )
        experience.should be_valid

        experience.starting_at = Date.current - 1.days
        experience.save.should be_true

        experience.starting_at = Date.current - 5.days
        experience.save.should be_true

        experience.starting_at = Date.current - 10.days
        experience.save.should be_false

        experience.starting_at = Date.current - 6.days
        experience.save.should be_false
      end
    end

    it "debe requerir un validity_starting_at mayor o igual que starting_at" do
      FactoryGirl.build(:experience,
                        starting_at:          Date.current,
                        validity_starting_at: (Date.current - 1.day),
                        ending_at:            (Date.current + 10.days),
                        validity_ending_at:   (Date.current + 11.days)).should_not be_valid

      FactoryGirl.build(:experience,
                        starting_at:          Date.current,
                        validity_starting_at: Date.current,
                        ending_at:            (Date.current + 10.days),
                        validity_ending_at:   (Date.current + 11.days)).should be_valid

      FactoryGirl.build(:experience,
                        starting_at:          Date.current,
                        validity_starting_at: (Date.current + 1.day),
                        ending_at:            (Date.current + 10.days),
                        validity_ending_at:   (Date.current + 11.days)).should be_valid
    end

    it "debe requerir un ending_at mayor o igual que validity_starting_at" do
      FactoryGirl.build(:experience,
                        starting_at:          Date.current,
                        validity_starting_at: (Date.current + 2.day),
                        ending_at:            (Date.current + 1.days),
                        validity_ending_at:   (Date.current + 11.days)).should_not be_valid

      FactoryGirl.build(:experience,
                        starting_at:          Date.current,
                        validity_starting_at: (Date.current + 1),
                        ending_at:            (Date.current + 1.days),
                        validity_ending_at:   (Date.current + 11.days)).should be_valid

      FactoryGirl.build(:experience,
                        starting_at:          Date.current,
                        validity_starting_at: (Date.current + 1.day),
                        ending_at:            (Date.current + 10.days),
                        validity_ending_at:   (Date.current + 11.days)).should be_valid
    end

    it "debe requerir un validity_ending_at mayor o igual que ending_at" do
      FactoryGirl.build(:experience,
                        starting_at:          Date.current,
                        validity_starting_at: (Date.current + 1.day),
                        ending_at:            (Date.current + 11.days),
                        validity_ending_at:   (Date.current + 10.days)).should_not be_valid

      FactoryGirl.build(:experience,
                        starting_at:          Date.current,
                        validity_starting_at: (Date.current + 1),
                        ending_at:            (Date.current + 10.days),
                        validity_ending_at:   (Date.current + 10.days)).should be_valid

      FactoryGirl.build(:experience,
                        starting_at:          Date.current,
                        validity_starting_at: (Date.current + 1.day),
                        ending_at:            (Date.current + 10.days),
                        validity_ending_at:   (Date.current + 11.days)).should be_valid
    end
  end

  describe "discounted_price" do
    it "debe requerir un discounted_price" do
      FactoryGirl.build(:experience, discounted_price: nil).should_not be_valid
      FactoryGirl.build(:experience, discounted_price: '').should_not be_valid
    end

    it "debe requerir un discounted_price numerico y entero" do
      ['published', 'active'].each do |s|
        subject.stub(:state){s}

        should validate_numericality_of(:discounted_price).only_integer

        FactoryGirl.build(:experience, discounted_price: 'a').should_not be_valid

        FactoryGirl.build(:experience, amount: 1, discounted_price: '1').should be_valid
        FactoryGirl.build(:experience, amount: 1, discounted_price: 1).should be_valid
      end
    end

    it "debe requerir un discounted_price mayor que cero" do
      FactoryGirl.build(:experience, discounted_price: '-1').should_not be_valid
      FactoryGirl.build(:experience, discounted_price: -1).should_not be_valid
      FactoryGirl.build(:experience, discounted_price: '0').should_not be_valid
      FactoryGirl.build(:experience, discounted_price: 0).should_not be_valid
      FactoryGirl.build(:experience, discounted_price: '-1.5').should_not be_valid
      FactoryGirl.build(:experience, discounted_price: -1.5).should_not be_valid
    end

    it "debe requerir un discounted_price menor o igual que amount" do
      FactoryGirl.build(:experience, amount: 10, discounted_price: '11').should_not be_valid
      FactoryGirl.build(:experience, amount: 10, discounted_price: 11).should_not be_valid

      [*1..10].each do |i|
        FactoryGirl.build(:experience, amount: 10, discounted_price: i).should be_valid
      end
    end
  end

  describe "discount_percentage" do
    context "cuando discounted_price esta presente" do
      it "no debe requerir un discount_percentage" do
        FactoryGirl.build(:experience, discount_percentage: nil).should be_valid
        FactoryGirl.build(:experience, discount_percentage: '').should  be_valid
      end
    end

    context "cuando discounted_price no esta presente" do
      it "debe requerir un discount_percentage" do
        FactoryGirl.build(:experience, discounted_price: nil, discount_percentage: nil).should_not be_valid
        FactoryGirl.build(:experience, discounted_price: nil, discount_percentage: '').should_not be_valid
      end

      it "debe requerir un discount_percentage numerico" do
        subject.stub(:discounted_price){nil}

        ['published', 'active'].each do |s|
          subject.stub(:state){'published'}

          should validate_numericality_of(:discount_percentage)

          eco = FactoryGirl.create(:eco, discount: 1)

          FactoryGirl.build(:experience, eco_id: eco.id, discounted_price: nil, discount_percentage: '1').should   be_valid
          FactoryGirl.build(:experience, eco_id: eco.id, discounted_price: nil, discount_percentage:  1).should    be_valid

          FactoryGirl.build(:experience, eco_id: eco.id, discounted_price: nil, discount_percentage: '2').should   be_valid
          FactoryGirl.build(:experience, eco_id: eco.id, discounted_price: nil, discount_percentage:  2).should    be_valid

          FactoryGirl.build(:experience, eco_id: eco.id, discounted_price: nil, discount_percentage: '2.5').should be_valid
          FactoryGirl.build(:experience, eco_id: eco.id, discounted_price: nil, discount_percentage:  2.5).should  be_valid
        end
      end

      it "debe requerir un discount_percentage mayor o igual que cero" do
        FactoryGirl.build(:experience, discounted_price: nil, discount_percentage: '-1').should_not   be_valid
        FactoryGirl.build(:experience, discounted_price: nil, discount_percentage:  -1).should_not    be_valid
        FactoryGirl.build(:experience, discounted_price: nil, discount_percentage: '-1.5').should_not be_valid
        FactoryGirl.build(:experience, discounted_price: nil, discount_percentage:  -1.5).should_not  be_valid
      end

      it "debe requerir un discount_percentage menor que 100" do
        FactoryGirl.build(:experience, discounted_price: nil, discount_percentage: '101').should_not   be_valid
        FactoryGirl.build(:experience, discounted_price: nil, discount_percentage:  101).should_not    be_valid
        FactoryGirl.build(:experience, discounted_price: nil, discount_percentage: '101.1').should_not be_valid
        FactoryGirl.build(:experience, discounted_price: nil, discount_percentage:  101.1).should_not  be_valid
        FactoryGirl.build(:experience, discounted_price: nil, discount_percentage:  '100').should_not  be_valid
        FactoryGirl.build(:experience, discounted_price: nil, discount_percentage:  100).should_not    be_valid
      end
    end
  end

  describe "industry_experiences" do
    context "cuando no esta pendiente" do
      it "debe requerir un industry_experiences" do
        ['published', 'active'].each do |s|
          experience = FactoryGirl.build(:experience, state: s)
          experience.industry_experiences.destroy_all
          experience.should_not be_valid
        end
      end

      it "debe requerir un industry_experiences valido" do
        industry1 = FactoryGirl.create :industry
        industry2 = FactoryGirl.create :industry
        ['published', 'active'].each do |s|
          experience = FactoryGirl.create(:experience, state: s)
          experience.should be_valid

          experience.industry_experiences.destroy_all
          FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry2.id, percentage: 99.0)
          experience.reload

          experience.should_not be_valid
        end
      end

      it "debe requerir un porcentaje global de 100%" do
        ['published', 'active'].each do |s|
          experience = FactoryGirl.create(:experience, state: s)
          industry1  = FactoryGirl.create(:industry)
          industry2  = FactoryGirl.create(:industry)

          experience.industry_experiences.destroy_all
          FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry1.id, percentage: 50.0)
          FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry2.id, percentage: 50.0)
          experience.reload

          experience.should be_valid
        end
      end

      it "debe construir industry_experiences si la experience no esta pendiente" do
        ['published', 'active'].each do |s|
          experience = FactoryGirl.build(:experience, state: s)
          experience.industry_experiences.should_not be_empty
        end
      end
    end

    context "cuando el estado es :pending" do
      it "no debe requerir un industry_experiences" do
        experience = FactoryGirl.build(:experience, state: 'draft')
        experience.industry_experiences.destroy_all
        experience.should be_valid
      end

      it "no debe construir industry_experiences si la experience esta en 'draft'" do
        experience = FactoryGirl.build(:experience, state: 'draft')
        experience.industry_experiences.should be_empty
      end
    end
  end

  it "no debe ser obligatorio subir :valid_images" do
    experience = FactoryGirl.create(:experience)
    experience.valid_images.count.should_not eq(0)
    experience.should be_valid

    experience.valid_images.destroy_all
    experience.valid_images.count.should eq(0)
    experience.should be_valid
  end

  it "debe requerir codigos en funcion de :swaps * :codes_by_purchase" do
    # spec/fixtures/experiences/codes.xlsx tiene solo 6 códigos
    file  = File.new(Rails.root + 'spec/fixtures/experiences/codes.xlsx')
    codes = ActionDispatch::Http::UploadedFile.new({ filename: 'codes.xlsx',
                                                     tempfile: file})

    experience = FactoryGirl.build(:experience, swaps: 6,
                                                codes_by_purchase: 1,
                                                file_codes: codes)

    experience.codes.count.should eq 6

    # 1 codigo 1 canje
    experience.codes_by_purchase = 1
    experience.swaps = 6
    experience.should be_valid

    # 2 codigos 1 canje
    experience.codes_by_purchase = 2
    experience.swaps = 6
    experience.should_not be_valid

    experience.codes_by_purchase = 2
    experience.swaps = 3
    experience.should be_valid

    # 6 codigos 1 canje
    experience.codes_by_purchase = 6
    experience.swaps = 1
    experience.should be_valid
  end

  ###########
  # methods #
  ###########
  context "para saber cuantas validacion se han realizado" do
    it "debe responder a :number_of_validations" do
      should respond_to :number_of_validations
    end

    it "debe devolver un valor correcto" do
      experience = FactoryGirl.create(:experience, swaps: 10)
      experience.starting_at = Date.today - 4.days
      experience.save validate: false

      experience.industry_experiences.destroy_all
      Industry.destroy_all
      industry   = FactoryGirl.create(:industry, percentage: 30)
      experience.industry_experiences << FactoryGirl.create(:industry_experience, industry_id: industry.id, experience_id: experience.id, percentage: 30.0)
      experience.industry_experiences << FactoryGirl.create(:industry_experience, experience_id: experience.id, percentage: 70.0)
      experience.reload
      experience.industry_experiences.should_not be_empty
      experience.number_of_validations.should eq(0)

      efi1       = FactoryGirl.create(:efi, industry_ids: [industry.id])
      efi2       = FactoryGirl.create(:efi, industry_ids: [industry.id])
      event1     = FactoryGirl.create(:event, experience_id: experience.id, efi_id: efi2.id, exclusivity_id: Exclusivity.without_id, swaps: 5)
      event2     = FactoryGirl.create(:event, experience_id: experience.id, efi_id: efi1.id, exclusivity_id: Exclusivity.by_industry_id)
      experience.number_of_validations.should eq(0)

      FactoryGirl.create(:purchase, exchange_id: event1.exchanges.first.id, state: 'validated')
      experience.number_of_validations.should eq(1)

      FactoryGirl.create(:purchase, exchange_id: event2.exchanges.first.id, state: 'sold')
      experience.number_of_validations.should eq(1)
    end
  end

  context "para saber cuanto stock se vendio" do
    it "debe responder a :stock_sold" do
      should respond_to :stock_sold
    end

    it "debe devolver un valor correcto" do
      experience = FactoryGirl.create(:experience, swaps: 10)
      experience.industry_experiences.destroy_all
      Industry.destroy_all
      industry   = FactoryGirl.create(:industry, percentage: 30)
      experience.industry_experiences << FactoryGirl.create(:industry_experience, experience_id: experience.id, percentage: 30.0, industry_id: industry.id)
      experience.industry_experiences << FactoryGirl.create(:industry_experience, experience_id: experience.id, percentage: 70.0)
      experience.reload
      experience.industry_experiences.should_not be_empty
      experience.stock_sold.should eq(0)

      efi1       = FactoryGirl.create(:efi, industry_ids: [industry.id])
      efi2       = FactoryGirl.create(:efi, industry_ids: [industry.id])

      experience.starting_at = Date.today - 4.days
      experience.save validate: false

      event1     = FactoryGirl.create(:event, experience_id: experience.id, efi_id: efi2.id, exclusivity_id: Exclusivity.without_id, swaps: 5)
      event2     = FactoryGirl.create(:event, experience_id: experience.id, efi_id: efi1.id, exclusivity_id: Exclusivity.by_industry_id)
      experience.stock_sold.should eq(event2.quantity)
      experience.stock_sold.should eq(3)

      FactoryGirl.create(:purchase, exchange_id: event1.exchanges.first.id)
      experience.stock_sold.should eq(event2.quantity + event1.purchases.count)
      experience.stock_sold.should eq(4)

      FactoryGirl.create(:purchase, exchange_id: event2.exchanges.first.id)
      experience.stock_sold.should eq(event2.quantity + event1.purchases.count)
      experience.stock_sold.should eq(4)
    end
  end

  context "para saber cuantas compras se realizaron" do
    it "debe responder a :number_of_issued" do
      should respond_to :number_of_issued
    end

    it "debe devolver un valor correcto" do
      experience = FactoryGirl.create(:experience, swaps: 10)
      experience.industry_experiences.destroy_all
      Industry.destroy_all
      industry   = FactoryGirl.create(:industry, percentage: 30)
      experience.industry_experiences << FactoryGirl.create(:industry_experience, industry_id: industry.id, experience_id: experience.id, percentage: 30.0)
      experience.industry_experiences << FactoryGirl.create(:industry_experience, experience_id: experience.id, percentage: 70.0)
      experience.reload
      experience.industry_experiences.should_not be_empty
      experience.number_of_issued.should eq(0)

      efi1       = FactoryGirl.create(:efi, industry_ids: [industry.id])
      efi2       = FactoryGirl.create(:efi, industry_ids: [industry.id])

      experience.starting_at = Date.today - 4.days
      experience.save validate: false

      event1     = FactoryGirl.create(:event, experience_id: experience.id, efi_id: efi2.id, exclusivity_id: Exclusivity.without_id, swaps: 5)
      event2     = FactoryGirl.create(:event, experience_id: experience.id, efi_id: efi1.id, exclusivity_id: Exclusivity.by_industry_id)
      experience.number_of_issued.should eq(0)

      FactoryGirl.create(:purchase, exchange_id: event1.exchanges.first.id)
      experience.number_of_issued.should eq(experience.purchases.count)
      experience.number_of_issued.should eq(1)

      FactoryGirl.create(:purchase, exchange_id: event2.exchanges.first.id)
      experience.number_of_issued.should eq(experience.purchases.count)
      experience.number_of_issued.should eq(2)
    end
  end

  describe 'category_name' do
    it "debe responder a category_name" do
      should respond_to :category_name
    end
  end

  describe 'category_texture_name' do
    it "debe responder a category_texture_name" do
      should respond_to :category_texture_name
    end
  end

  # describe 'comuna_name' do
  #   it "debe responder a comuna_name" do
  #     should respond_to :comuna_name
  #   end
  # end

  describe 'available_total_exclusivity?' do
    it "debe responder a available_total_exclusivity?" do
      should respond_to :available_total_exclusivity?
    end

    context "cuando no hay ningun evento" do
      it "debe devolver TRUE" do
        experience = FactoryGirl.create(:experience)
        experience.events.destroy_all
        experience.available_total_exclusivity?().should be_true
      end
    end

    context "cuando ya tomaron la 'exclusividad total'" do
      it "debe devolver FALSE" do
        event = FactoryGirl.create(:event, exclusivity_id: Exclusivity.total_id)
        experience = event.experience
        experience.reload

        experience.available_total_exclusivity?().should be_false
      end
    end

    context "cuando ya tomaron la exclusividad por industria" do
      it "debe devolver FALSE" do
        experience = FactoryGirl.create(:experience)
        experience.starting_at = Date.today - 4.days
        experience.save validate: false

        industry   = experience.industry_experiences.first.industry
        efi        = FactoryGirl.create(:efi, industry_ids: [industry.id])

        event = FactoryGirl.create(:event, exclusivity_id: Exclusivity.by_industry_id, efi_id:  efi.id, experience_id: experience.id)
        experience.available_total_exclusivity?().should be_false
      end
    end

    context "cuando ya tomaron 'sin exclusividad'" do
      it "debe devolver FALSE" do
        experience = FactoryGirl.create(:experience, total_exclusivity_sales: false, by_industry_exclusivity_sales: false)
        event = FactoryGirl.create(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id, swaps: 1)
        experience = event.experience
        experience.reload
        experience.available_total_exclusivity?().should be_false
      end
    end
  end

  describe 'available_exclusivity_by_industry?' do
    it "debe responder a available_exclusivity_by_industry?" do
      should respond_to :available_exclusivity_by_industry?
    end

    context "cuando no hay ningun evento" do
      it "debe devolver TRUE" do
        experience = FactoryGirl.create(:experience)
        industry   = experience.industry_experiences.first.industry
        efi        = FactoryGirl.create(:efi, industry_ids: [industry.id])

        experience.events.destroy_all
        experience.available_exclusivity_by_industry?(efi).should be_true
      end
    end

    context "cuando hay solo eventos 'sin exclusividad'" do
      it "debe devolver TRUE" do
        experience = FactoryGirl.create(:experience, total_exclusivity_sales: false, by_industry_exclusivity_sales: false)
        event = FactoryGirl.create(:event, experience_id: experience.id, exclusivity_id: Exclusivity.without_id, swaps: 1)

        experience = event.experience
        industry   = experience.industry_experiences.first.industry
        efi        = FactoryGirl.create(:efi, industry_ids: [industry.id])

        experience.available_exclusivity_by_industry?(efi).should be_true
      end
    end

    context "cuando ya tomaron la 'exclusividad por industria'" do
      context "cuando son efis de distintas industrias" do
        it "debe devolver TRUE" do
          experience = FactoryGirl.create(:experience, total_exclusivity_sales: false)
          industry1  = FactoryGirl.create(:industry)
          industry2  = FactoryGirl.create(:industry)
          efi1       = FactoryGirl.create(:efi, industry_ids: [industry1.id])
          efi2       = FactoryGirl.create(:efi, industry_ids: [industry2.id])

          experience.industry_experiences.destroy_all
          FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry1.id, percentage: 50.0)
          FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry2.id, percentage: 50.0)
          experience.reload


          event = FactoryGirl.create(:event, exclusivity_id: Exclusivity.by_industry_id, efi_id:  efi1.id, experience_id: experience.id)

          experience.available_exclusivity_by_industry?(efi2).should be_true
        end
      end
      context "cuando son efis de la misma industria" do
        it "debe devolver FALSE" do
          experience = FactoryGirl.create(:experience, total_exclusivity_sales: false)
          industry   = experience.industry_experiences.first.industry
          efi1       = FactoryGirl.create(:efi, industry_ids: [industry.id])
          efi2       = FactoryGirl.create(:efi, industry_ids: [industry.id])

          event = FactoryGirl.create(:event, exclusivity_id: Exclusivity.by_industry_id, efi_id:  efi1.id, experience_id: experience.id)

          experience.available_exclusivity_by_industry?(efi2).should be_false
        end
      end
    end

    context "cuando ya tomaron la 'exclusividad total'" do
      it "debe devolver FALSE" do
        efi        = FactoryGirl.create(:efi)
        experience = FactoryGirl.create(:experience)
        industry   = experience.industry_experiences.first.industry
        efi.industries << industry

        event = FactoryGirl.create(:event, exclusivity_id: Exclusivity.total_id, experience_id: experience.id)

        experience.available_exclusivity_by_industry?(efi).should be_false
      end
    end
  end

  describe 'available_without_exclusivity?' do
    it "debe responder a available_without_exclusivity?" do
      should respond_to :available_without_exclusivity?
    end

    it "debe devolver TRUE" do
      experience = FactoryGirl.create(:experience)
      experience.events.destroy_all
      experience.available_without_exclusivity?().should be_true
    end

    context "cuando ya tomaron la 'exclusividad total'" do
      it "debe devolver FALSE" do
        event = FactoryGirl.create(:event, exclusivity_id: Exclusivity.total_id)
        event.experience.available_without_exclusivity?().should be_false
      end
    end
  end

  describe 'industry_swaps' do
    it "debe responder a industry_swaps" do
      should respond_to :industry_swaps
    end

    it "debe devolver un valor valido" do
      industry1  = FactoryGirl.create(:industry)
      industry2  = FactoryGirl.create(:industry)
      industry3  = FactoryGirl.create(:industry)
      experience = FactoryGirl.create(:experience, swaps: 100, codes: [], codes_by_purchase: nil)
      efi1       = FactoryGirl.create(:efi, industry_ids: [industry1.id])
      efi2       = FactoryGirl.create(:efi, industry_ids: [industry2.id])
      efi3       = FactoryGirl.create(:efi, industry_ids: [industry1.id, industry2.id])
      efi4       = FactoryGirl.create(:efi, industry_ids: [industry1.id, industry2.id, industry3.id])

      experience.industry_experiences.destroy_all
      FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry1.id, percentage: 50.0)
      FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry2.id, percentage: 40.0)
      FactoryGirl.create(:industry_experience, experience_id: experience.id, industry_id: industry3.id, percentage: 10.0)
      experience.reload

      experience.industry_swaps(efi1).should eq  50.0
      experience.industry_swaps(efi2).should eq  40.0
      experience.industry_swaps(efi3).should eq  90.0
      experience.industry_swaps(efi4).should eq 100.0
    end
  end

  describe 'minimum_without_swaps' do
    it "debe responder a minimum_without_swaps" do
      should respond_to :minimum_without_swaps
    end
  end

  context 'al crear nuevas experiences' do
    it "debe setear starting_at por defecto" do
      Experience.new.starting_at.should_not be_nil
    end

    it "debe setear ending_at por defecto" do
      Experience.new.ending_at.should_not be_nil
    end

    it "debe setear validity_starting_at por defecto" do
      Experience.new.validity_starting_at.should_not be_nil
    end

    it "debe setear validity_ending_at por defecto" do
      Experience.new.validity_ending_at.should_not be_nil
    end
  end

  it "codes debe ser un arreglo" do
    FactoryGirl.build(:experience).codes.class.should eq Array
  end

  describe "file_codes" do
    it "debe leer los códigos desde el archivos" do
      file  = File.new(Rails.root + 'spec/fixtures/experiences/codes.xlsx')
      codes = ActionDispatch::Http::UploadedFile.new({ filename: 'codes.xlsx',
                                                       tempfile: file})

      experience = FactoryGirl.create(:experience, swaps: 6, file_codes: codes)
      experience.codes.should_not be_empty
    end

    it "debe excluir los códigos duplicados" do
      file  = File.new(Rails.root + 'spec/fixtures/experiences/duplicated_codes.xlsx')
      codes = ActionDispatch::Http::UploadedFile.new({ filename: 'duplicated_codes.xlsx',
                                                       tempfile: file})

      experience = FactoryGirl.create(:experience, swaps: 6, file_codes: codes)
      experience.codes.should_not be_empty
      experience.codes.count.should eq 6
    end
  end

  it "debe aceptar attributos nesteados para :industry_experiences" do
    should accept_nested_attributes_for :industry_experiences
  end

  it "debe aceptar attributos nesteados para :experience_advertisings" do
    should accept_nested_attributes_for :experience_advertisings
  end

  describe 'para filtrar Experiences' do
    it "deberia responder a are_published" do
      Experience.should respond_to :are_published
    end

    it "deberia responder a are_closed" do
      Experience.should respond_to :are_closed
    end

    # it "deberia responder a expired_billed_or_paid" do
    #   Experience.should respond_to :expired_billed_or_paid
    # end
    #
    # it "deberia responder a published_or_on_sale" do
    #   Experience.should respond_to :published_or_on_sale
    # end
    #
    # it "deberia responder a on_sale_or_closed" do
    #   Experience.should respond_to :on_sale_or_closed
    # end
    #
    # it "deberia responder a pending_published_on_sale_or_closed" do
    #   Experience.should respond_to :pending_published_on_sale_or_closed
    # end

    it "deberia responder a was_published" do
      Experience.should respond_to :was_published
    end
  end

  context 'para obtener el estado en que se encuentra la experience' do
    it "debe responder a translate_state" do
      should respond_to :translate_state
    end

    it "debe responder con una traducción legible" do
      event = FactoryGirl.create(:event)
      ['taken', 'closed', 'billed', 'paid'].each do |s|
        event.state = s
        event.translate_state.include?('translation missing:').should be_false
      end

      event.state = 'estado_no_existente'
      event.translate_state.include?('translation missing:').should be_false
      event.translate_state.should eq('estado_no_existente')
    end
  end

  context 'para si la experience se encuentra en algun(os) estado en particular' do
    it "debe responder a in_state?" do
      should respond_to :in_state?
    end

    it "debe responder con un valor valido" do
      experience = FactoryGirl.create(:experience, state: 'published')
      experience.in_state?(['published']).should be_true
      experience.in_state?('published').should be_true
      experience.in_state?(:published).should be_true
      experience.in_state?(['draft', 'published', 'active', 'closed', 'expired']).should be_true
      experience.in_state?([:draft, :published, :active, :closed, :expired]).should be_true

      experience.in_state?(['draft', 'active', 'closed', 'expired']).should be_false
      experience.in_state?(1).should be_nil
      experience.in_state?(nil).should be_nil
    end
  end

  describe 'purchases' do
    it "debe responder a purchases" do
      should respond_to :purchases
    end
  end

  describe "para saber con que exclusividad puedo participar en una experience" do
    it "debe responder a :total_exclusivity_enabled?" do
      subject.stub(:state){'published'}
      should respond_to :total_exclusivity_enabled?
    end

    it "debe responder a :by_industry_exclusivity_enabled?" do
      subject.stub(:state){'published'}
      should respond_to :by_industry_exclusivity_enabled?
    end

    it "debe responder a :without_exclusivity_enabled?" do
      subject.stub(:state){'published'}
      should respond_to :without_exclusivity_enabled?
    end

    context ":total_exclusivity_sales & :by_industry_exclusivity_sales & :without_exclusivity_sales" do
      it "debe retornar un valor valido" do
        experience = FactoryGirl.create(:experience,
                                        total_exclusivity_sales:       true, total_exclusivity_days:       2,
                                        by_industry_exclusivity_sales: true, by_industry_exclusivity_days: 2,
                                        without_exclusivity_sales:     true)

        day = experience.starting_at

        experience.total_exclusivity_enabled?.should be_true
        experience.by_industry_exclusivity_enabled?.should be_false
        experience.without_exclusivity_enabled?.should be_false

        experience.starting_at = day - 2.days
        experience.total_exclusivity_enabled?.should be_true
        experience.by_industry_exclusivity_enabled?.should be_true
        experience.without_exclusivity_enabled?.should be_false

        experience.starting_at = day - 4.days
        experience.total_exclusivity_enabled?.should be_true
        experience.by_industry_exclusivity_enabled?.should be_true
        experience.without_exclusivity_enabled?.should be_true
      end
    end

    context ":total_exclusivity_sales & :by_industry_exclusivity_sales" do
      it "debe retornar un valor valido" do
        experience = FactoryGirl.create(:experience,
                                        total_exclusivity_sales:       true, total_exclusivity_days:       2,
                                        by_industry_exclusivity_sales: true, by_industry_exclusivity_days: nil,
                                        without_exclusivity_sales:     false)

        day = experience.starting_at

        experience.total_exclusivity_enabled?.should be_true
        experience.by_industry_exclusivity_enabled?.should be_false
        experience.without_exclusivity_enabled?.should be_false

        experience.starting_at = day - 2.days
        experience.total_exclusivity_enabled?.should be_true
        experience.by_industry_exclusivity_enabled?.should be_true
        experience.without_exclusivity_enabled?.should be_false

        experience.starting_at = day - 4.days
        experience.total_exclusivity_enabled?.should be_true
        experience.by_industry_exclusivity_enabled?.should be_true
        experience.without_exclusivity_enabled?.should be_false
      end
    end

    context ":total_exclusivity_sales & :without_exclusivity_sales" do
      it "debe retornar un valor valido" do
        experience = FactoryGirl.create(:experience,
                                        total_exclusivity_sales:       true,  total_exclusivity_days:       2,
                                        by_industry_exclusivity_sales: false, by_industry_exclusivity_days: nil,
                                        without_exclusivity_sales:     true)

        day = experience.starting_at

        experience.total_exclusivity_enabled?.should be_true
        experience.by_industry_exclusivity_enabled?.should be_false
        experience.without_exclusivity_enabled?.should be_false

        experience.starting_at = day - 2.days
        experience.total_exclusivity_enabled?.should be_true
        experience.by_industry_exclusivity_enabled?.should be_false
        experience.without_exclusivity_enabled?.should be_true

        experience.starting_at = day - 4.days
        experience.total_exclusivity_enabled?.should be_true
        experience.by_industry_exclusivity_enabled?.should be_false
        experience.without_exclusivity_enabled?.should be_true
      end
    end

    context ":by_industry_exclusivity_sales & :without_exclusivity_sales" do
      it "debe retornar un valor valido" do
        experience = FactoryGirl.create(:experience,
                                        total_exclusivity_sales:       false, total_exclusivity_days:      nil,
                                        by_industry_exclusivity_sales: true, by_industry_exclusivity_days: 2,
                                        without_exclusivity_sales:     true)

        day = experience.starting_at

        experience.total_exclusivity_enabled?.should be_false
        experience.by_industry_exclusivity_enabled?.should be_true
        experience.without_exclusivity_enabled?.should be_false

        experience.starting_at = day - 2.days
        experience.total_exclusivity_enabled?.should be_false
        experience.by_industry_exclusivity_enabled?.should be_true
        experience.without_exclusivity_enabled?.should be_true

        experience.starting_at = day - 4.days
        experience.total_exclusivity_enabled?.should be_false
        experience.by_industry_exclusivity_enabled?.should be_true
        experience.without_exclusivity_enabled?.should be_true
      end
    end

    context ":total_exclusivity_sales" do
      it "debe retornar un valor valido" do
        experience = FactoryGirl.create(:experience,
                                        total_exclusivity_sales:       true,  total_exclusivity_days:       nil,
                                        by_industry_exclusivity_sales: false, by_industry_exclusivity_days: nil,
                                        without_exclusivity_sales:     false)

        day = experience.starting_at

        Date.stub!(:today).and_return(day)
        experience.total_exclusivity_enabled?.should be_true
        experience.by_industry_exclusivity_enabled?.should be_false
        experience.without_exclusivity_enabled?.should be_false

        Date.stub!(:today).and_return(day - 100.days)
        experience.total_exclusivity_enabled?.should be_true
        experience.by_industry_exclusivity_enabled?.should be_false
        experience.without_exclusivity_enabled?.should be_false
      end
    end

    context ":by_industry_exclusivity_sales" do
      it "debe retornar un valor valido" do
        experience = FactoryGirl.create(:experience,
                                        total_exclusivity_sales:       false,  total_exclusivity_days:       nil,
                                        by_industry_exclusivity_sales: true,   by_industry_exclusivity_days: nil,
                                        without_exclusivity_sales:     false)

        day = experience.starting_at

        Date.stub!(:today).and_return(day)
        experience.total_exclusivity_enabled?.should be_false
        experience.by_industry_exclusivity_enabled?.should be_true
        experience.without_exclusivity_enabled?.should be_false

        Date.stub!(:today).and_return(day - 100.days)
        experience.total_exclusivity_enabled?.should be_false
        experience.by_industry_exclusivity_enabled?.should be_true
        experience.without_exclusivity_enabled?.should be_false
      end
    end

    context ":without_exclusivity_sales" do
      it "debe retornar un valor valido" do
        experience = FactoryGirl.create(:experience,
                                        total_exclusivity_sales:       false, total_exclusivity_days:       nil,
                                        by_industry_exclusivity_sales: false, by_industry_exclusivity_days: nil,
                                        without_exclusivity_sales:     true)

        day = experience.starting_at

        Date.stub!(:today).and_return(day)
        experience.total_exclusivity_enabled?.should be_false
        experience.by_industry_exclusivity_enabled?.should be_false
        experience.without_exclusivity_enabled?.should be_true

        Date.stub!(:today).and_return(day - 100.days)
        experience.total_exclusivity_enabled?.should be_false
        experience.by_industry_exclusivity_enabled?.should be_false
        experience.without_exclusivity_enabled?.should be_true
      end
    end
  end

  #################
  # state_machine #
  #################
  describe "state_machine" do
    context "states" do
      it "debe tener estados" do
        FactoryGirl.create(:experience, state: 'draft').should be_valid
        FactoryGirl.create(:experience, state: 'published').should be_valid
        FactoryGirl.create(:experience, state: 'closed').should be_valid
        FactoryGirl.create(:experience, state: 'expired').should be_valid

        expect {
          FactoryGirl.create(:experience, state: 'not_valid')
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "events" do
      describe "sell!" do
        it "debe cambiar el estado" do
          experience = FactoryGirl.create(:experience, state: 'published')
          experience.published?.should be_true
          experience.sell!.should be_true
          experience.active?.should be_true
        end

        it "no debe cambiar el estado" do
          ['draft', 'active', 'closed', 'expired'].each do |s|
            experience = FactoryGirl.create(:experience, state: s)
            experience.sell!.should be_false
          end
        end
      end

      describe "close!" do
        it "debe cambiar el estado" do
          ['active'].each do |s|
            experience = FactoryGirl.create(:experience, state: s)
            experience.industry_experiences.destroy_all
            FactoryGirl.create(:industry_experience, experience_id: experience.id, percentage: 100)
            experience.reload

            experience.close!.should be_true
            experience.closed?.should be_true
          end
        end

        it "no debe cambiar el estado" do
          ['draft', 'closed', 'expired'].each do |s|
            experience = FactoryGirl.create(:experience, state: s)
            experience.close!.should be_false
          end
        end
      end

      describe "expire!" do
        it "debe cambiar el estado" do
          ['published', 'active', 'closed'].each do |s|
            experience = FactoryGirl.create(:experience, state: s)
            experience.expire!.should be_true
            experience.expired?.should be_true
          end
        end

        it "no debe cambiar el estado" do
          experience = FactoryGirl.create(:experience, state: 'draft')
          experience.expire!.should be_false
        end
      end
    end
  end
end
