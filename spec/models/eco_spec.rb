# encoding: utf-8
require 'spec_helper'

describe Eco do
  ##############
  # attributes #
  ##############
  describe "attributes" do
    it "debe responder a logo" do
      should respond_to :logo
    end

    it "debe responder a name" do
      should respond_to :name
    end

    it "debe responder a rut" do
      should respond_to :rut
    end

    it "debe responder a webpage" do
      should respond_to :webpage
    end

    # it "debe responder a images" do
    #   should respond_to :images
    # end

    it "debe responder a fancy_name" do
      should respond_to :fancy_name
    end

    it "debe responder a address" do
      should respond_to :address
    end

    it "debe responder a discount" do
      should respond_to :discount
    end

    it "debe responder a fee" do
      should respond_to :fee
    end

    it "debe responder a comuna_id" do
      should respond_to :comuna_id
    end

    it "debe responder a admin_id" do
      should respond_to :admin_id
    end

    it "debe responder a description" do
      should respond_to :description
    end
 
    it "debe responder a bigger" do
      should respond_to :bigger
    end
  end

  ################
  # associations #
  ################
  describe "associations" do
    it "debe tener muchos experiences" do
      should have_many(:experiences).dependent(:destroy)
    end

    it "debe pertenecer a comuna" do
      should belong_to(:comuna)
    end

    it "debe pertenecer a admin" do
      should belong_to(:admin)
    end

    it "debe tener muchos user_ecos" do
      should have_many(:user_ecos).dependent(:destroy)
    end

    it "debe tener muchos events" do
      should have_many(:events).through(:experiences)
    end

    it "debe tener muchos publicities" do
      should have_many(:publicities).through(:events)
    end
  end

  ###############
  # validations #
  ###############
  it "debe tener una Factory válida" do
    FactoryGirl.build(:eco).should be_valid
  end

  describe ":name validations" do
    it "debe requerir un name" do
      FactoryGirl.build(:eco, name: nil).should_not be_valid
      FactoryGirl.build(:eco, name: '').should_not be_valid
    end

    it "debe requerir un name único" do
      FactoryGirl.create(:eco, name: 'alfa')
      FactoryGirl.build(:eco,  name: 'alfa').should_not be_valid
    end
  end

  it "debe requerir un fancy_name" do
    FactoryGirl.build(:eco, fancy_name: nil).should_not be_valid
    FactoryGirl.build(:eco, fancy_name: '').should_not be_valid
  end

  it "debe requerir un address" do
    FactoryGirl.build(:eco, address: nil).should_not be_valid
    FactoryGirl.build(:eco, address: '').should_not be_valid
  end

  describe ":discount validations" do
    it "debe requerir un discount" do
      FactoryGirl.build(:eco, discount: nil).should_not be_valid
      FactoryGirl.build(:eco, discount: '').should_not be_valid
    end

    it "debe requerir un discount mayor o igual que 0" do
      FactoryGirl.build(:eco, discount: -1).should_not   be_valid
      FactoryGirl.build(:eco, discount: '-1').should_not be_valid

      FactoryGirl.build(:eco, discount: 0).should   be_valid
      FactoryGirl.build(:eco, discount: '0').should be_valid

      FactoryGirl.build(:eco, discount: 1).should   be_valid
      FactoryGirl.build(:eco, discount: '1').should be_valid
    end

    it "debe requerir un discount menor que 100" do
      FactoryGirl.build(:eco, discount: 101).should_not   be_valid
      FactoryGirl.build(:eco, discount: '101').should_not be_valid

      FactoryGirl.build(:eco, discount: 100).should_not   be_valid
      FactoryGirl.build(:eco, discount: '100').should_not be_valid

      FactoryGirl.build(:eco, discount: 99).should   be_valid
      FactoryGirl.build(:eco, discount: '99').should be_valid
    end
  end

  describe ":fee validations" do
    it "debe requerir un fee" do
      FactoryGirl.build(:eco, fee: nil).should_not be_valid
      FactoryGirl.build(:eco, fee: '').should_not  be_valid
    end

    it "debe requerir un fee mayor o igual que 0" do
      FactoryGirl.build(:eco, fee: -1).should_not   be_valid
      FactoryGirl.build(:eco, fee: '-1').should_not be_valid

      FactoryGirl.build(:eco, fee: 0).should   be_valid
      FactoryGirl.build(:eco, fee: '0').should be_valid

      FactoryGirl.build(:eco, fee: 1).should   be_valid
      FactoryGirl.build(:eco, fee: '1').should be_valid
    end

    it "debe requerir un fee menor o igual que 100" do
      FactoryGirl.build(:eco, fee: 101).should_not   be_valid
      FactoryGirl.build(:eco, fee: '101').should_not be_valid

      FactoryGirl.build(:eco, fee: 100).should   be_valid
      FactoryGirl.build(:eco, fee: '100').should be_valid

      FactoryGirl.build(:eco, fee: 99).should   be_valid
      FactoryGirl.build(:eco, fee: '99').should be_valid
    end
  end

  it "debe requerir un comuna_id" do
    FactoryGirl.build(:eco, comuna_id: nil).should_not be_valid
    FactoryGirl.build(:eco, comuna_id: '').should_not be_valid
  end

  it "debe requerir un admin_id" do
    FactoryGirl.build(:eco, admin_id: nil).should_not be_valid
    FactoryGirl.build(:eco, admin_id: '').should_not be_valid
  end

  describe ":webpage validations" do
    it "debe requerir un webpage" do
      FactoryGirl.build(:eco, webpage: nil).should_not be_valid
      FactoryGirl.build(:eco, webpage: '').should_not be_valid
    end

    it "debe validatar el formato de para webpage" do
      FactoryGirl.build(:eco,  webpage: '1234').should_not be_valid
      FactoryGirl.build(:eco,  webpage: 'asdf').should_not be_valid
      FactoryGirl.build(:eco,  webpage: 'email@dominio.cl').should_not be_valid
      FactoryGirl.build(:eco,  webpage: 'dominio.cl').should_not be_valid
      FactoryGirl.build(:eco,  webpage: 'www.dominio.cl').should_not be_valid
      FactoryGirl.build(:eco,  webpage: 'asdf.dominio.cl').should_not be_valid
      FactoryGirl.build(:eco,  webpage: '1234.dominio.cl').should_not be_valid
      FactoryGirl.build(:eco,  webpage: 'asdf://dominio.cl').should_not be_valid
      FactoryGirl.build(:eco,  webpage: 'asdf://asdf.dominio.cl').should_not be_valid
      FactoryGirl.build(:eco,  webpage: 'asdf://1234.dominio.cl').should_not be_valid
      FactoryGirl.build(:eco,  webpage: '1234://dominio.cl').should_not be_valid
      FactoryGirl.build(:eco,  webpage: '1234://asdf.dominio.cl').should_not be_valid
      FactoryGirl.build(:eco,  webpage: '1234://1234.dominio.cl').should_not be_valid

      FactoryGirl.build(:eco,  webpage: 'http://www.dominio.cl').should be_valid
      FactoryGirl.build(:eco,  webpage: 'https://www.dominio.cl').should be_valid
      FactoryGirl.build(:eco,  webpage: 'http://dominio.cl').should be_valid
      FactoryGirl.build(:eco,  webpage: 'https://dominio.cl').should be_valid
    end
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

  describe ":rut validations" do
    it "debe requerir un rut" do
      FactoryGirl.build(:eco, rut: nil).should_not be_valid
      FactoryGirl.build(:eco, rut: '').should_not  be_valid
    end

    it "debe requerir un rut único" do
      FactoryGirl.create(:eco, rut: '11.111.111-1')
      FactoryGirl.build(:eco,  rut: '11.111.111-1').should_not be_valid
    end

    it "debe requerir un rut válido" do
      FactoryGirl.build(:eco, rut: '11111111 1'  ).should_not be_valid
      FactoryGirl.build(:eco, rut: '11.111.111 1').should_not be_valid
      FactoryGirl.build(:eco, rut: '11 111 111 1').should_not be_valid
      FactoryGirl.build(:eco, rut: '11111.1111'  ).should_not be_valid
      FactoryGirl.build(:eco, rut: '11111.111-1' ).should_not be_valid
      FactoryGirl.build(:eco, rut: '11.1111111'  ).should_not be_valid
      FactoryGirl.build(:eco, rut: '11.111111-1' ).should_not be_valid
      FactoryGirl.build(:eco, rut: '11.111.1111' ).should_not be_valid
      FactoryGirl.build(:eco, rut: '11.111.111.1').should_not be_valid

      FactoryGirl.build(:eco, rut: '111111111'   ).should be_valid
      FactoryGirl.build(:eco, rut: '11111111-1'  ).should be_valid
      FactoryGirl.build(:eco, rut: '11.111.111-1').should be_valid

      FactoryGirl.build(:eco, rut: Run.for(:eco, :rut)).should be_valid
    end
  end

  it "debe requerir un bigger booleano" do
    FactoryGirl.build(:eco, bigger: nil).should_not be_valid
    FactoryGirl.build(:eco, bigger: '').should_not  be_valid

    FactoryGirl.build(:eco, bigger: true).should  be_valid
    FactoryGirl.build(:eco, bigger: false).should be_valid
  end

  ###########
  # methods #
  ###########
  it "debe setaer el formato básio de una webpage" do
    Eco.new.webpage.should eq 'http://www.'
  end

  it "debe responder a comuna_name" do
    should respond_to :comuna_name
  end

  it "debe responder a admin_name" do
    should respond_to :admin_name
  end

  describe 'para filtrar ECO' do
    it "deberia responder a big" do
      Eco.should respond_to :big
    end

    it "deberia responder a small" do
      Eco.should respond_to :small
    end
  end
end
