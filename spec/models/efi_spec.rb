# encoding: utf-8
require 'spec_helper'

describe Efi do
  ##############
  # attributes #
  ##############
  it "debe responder a logo" do
    should respond_to :logo
  end

  it "debe responder a name" do
    should respond_to :name
  end

  it "debe responder a rut" do
    should respond_to :rut
  end

  it "debe responder a industry_ids" do
    should respond_to :industry_ids
  end

  it "debe responder a zona" do
    should respond_to :zona
  end

  it "debe responder a search_name" do
    should respond_to :search_name
  end

  it "debe responder a connector_name" do
    should respond_to :connector_name
  end

  it "debe responder a compared" do
    should respond_to :compared
  end

  ################
  # associations #
  ################
  it "debe tener muchos user_efis" do
    should have_many(:user_efis).dependent(:destroy)
  end

  it "debe tener muchos industry_efis" do
    should have_many(:industry_efis).dependent(:destroy)
  end

  it "debe tener muchos industries" do
    should have_many(:industries).through(:industry_efis)
  end

  it "debe tener muchos experience_efis" do
    should have_many(:experience_efis).dependent(:destroy)
  end

  it "debe tener muchos available_experiences" do
    should have_many(:available_experiences).through(:experience_efis)
  end

  it "debe tener muchos events" do
    should have_many(:events).dependent(:destroy)
  end

  it "debe tener muchos accounts" do
    should have_many(:accounts).dependent(:destroy)
  end

  it "debe tener muchos banners" do
    should have_many(:banners).through(:events)
  end

  it "debe tener muchos publicities" do
    should have_many(:publicities).through(:events)
  end

  it "debe tener muchos exchanges" do
    should have_many(:exchanges).through(:events)
  end

  it "debe tener muchos purchases" do
    should have_many(:purchases).through(:exchanges)
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:efi).should be_valid
  end

  it "debe requerir un name" do
    FactoryGirl.build(:efi, name: nil).should_not be_valid
    FactoryGirl.build(:efi, name: '').should_not be_valid
  end

  it "debe requerir un zona" do
    FactoryGirl.build(:efi, zona: nil).should_not be_valid
    FactoryGirl.build(:efi, zona: '').should_not be_valid
  end

  it "debe requerir un search_name" do
    FactoryGirl.build(:efi, search_name: nil).should_not be_valid
    FactoryGirl.build(:efi, search_name: '').should_not  be_valid
  end

  it "debe requerir un search_name único" do
    FactoryGirl.create(:efi, search_name: 'efi')
    FactoryGirl.build(:efi, search_name: 'efi').should_not  be_valid
  end

  it "debe requerir un connector_name" do
    FactoryGirl.build(:efi, connector_name: nil).should_not be_valid
    FactoryGirl.build(:efi, connector_name: '').should_not  be_valid
  end

  it "debe requerir al menos una industry" do
    efi = FactoryGirl.build(:efi)
    efi.industry_efis.destroy_all
    efi.should_not be_valid

    efi.industries << FactoryGirl.create(:industry)
    efi.should be_valid
  end

  it "debe requerir un logo" do
    should validate_attachment_presence(:logo)
  end

  # it "debe validar el contenido del logo" do
  #   should validate_attachment_content_type(:logo).allowing('image/png', 'image/gif').rejecting('text/plain', 'text/xml')
  # end
  # it "debe validar el tamaño del logo" do
  #   should validate_attachment_size(:logo).less_than(2.megabytes)
  # end

  it "debe requerir un rut" do
    FactoryGirl.build(:efi, rut: nil).should_not be_valid
    FactoryGirl.build(:efi, rut: '').should_not  be_valid
  end

  it "debe requerir un rut único" do
    FactoryGirl.create(:efi, rut: '11.111.111-1')
    FactoryGirl.build(:efi,  rut: '11.111.111-1').should_not be_valid
  end

  it "debe requerir un rut válido" do
    FactoryGirl.build(:efi, rut: '11111111 1'  ).should_not be_valid
    FactoryGirl.build(:efi, rut: '11.111.111 1').should_not be_valid
    FactoryGirl.build(:efi, rut: '11 111 111 1').should_not be_valid
    FactoryGirl.build(:efi, rut: '11111.1111'  ).should_not be_valid
    FactoryGirl.build(:efi, rut: '11111.111-1' ).should_not be_valid
    FactoryGirl.build(:efi, rut: '11.1111111'  ).should_not be_valid
    FactoryGirl.build(:efi, rut: '11.111111-1' ).should_not be_valid
    FactoryGirl.build(:efi, rut: '11.111.1111' ).should_not be_valid
    FactoryGirl.build(:efi, rut: '11.111.111.1').should_not be_valid

    FactoryGirl.build(:efi, rut: '111111111'   ).should be_valid
    FactoryGirl.build(:efi, rut: '11111111-1'  ).should be_valid
    FactoryGirl.build(:efi, rut: '11.111.111-1').should be_valid

    FactoryGirl.build(:efi, rut: Run.for(:efi, :rut)).should be_valid
  end

  ###########
  # methods #
  ###########
  define 'full_search_name' do
    it 'debe responder a full_search_name' do
      should respond_to :full_search_name
    end

    it 'deberia reponder con la url a la mini pagina de la EFI' do
      FactoryGirl.build(:efi, search_name: 'efi1').should eq('http://localhost:3000/efi1')
    end
  end

  define "get_connector" do
    it 'debe responder a get_connector' do
      should respond_to :get_connector
    end
    it "deberia devolver un conector" do
      FactoryGirl.build(:efi, connector_name: 'BaseConnector').get_connector.class BaseConnector
    end
  end

  describe "para filtrar EFI's" do
    it "deberia responder a are_compared" do
      Efi.should respond_to :are_compared
    end
  end
end
