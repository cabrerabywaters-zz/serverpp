# coding: utf-8
require 'factory_girl'

namespace :app do
  
  def create_efi(name, industry_name)
    industry = Industry.find_by_name!(industry_name)
    efi = FactoryGirl.build(:efinew, name: name)
    efi.industries = [industry]
    efi.save!
    
    efi_user = FactoryGirl.build(:efi_user, names: name)
    efi_user.efi = efi
    efi_user.save
    
    10.times do |n|
      client_name = "Cliente #{n}"
      create_clients(client_name, efi)
    end
  end
  
  def create_clients(name, efi)
    FactoryGirl.create(:client, name: name, efi: efi)
  end
  
  def create_eco(name)
    eco = FactoryGirl.create(:econew, name: name)
    
    # FIXME: Admin Group should be the same for all ECOs
    eco_user = FactoryGirl.build(:eco_user, names: name)
    eco_user.eco = eco
    eco_user.save!
  end
  
  def create_experiences(eco_name)
    eco = Eco.find_by_name!(eco_name)
    eco_folder = eco_name.downcase.gsub(/\s+/, '')
    Dir.glob(Rails.root.join('db', 'images', 'experiences', eco_folder, '*.jpg')).each do |image_name|
      experience_name = File.basename(image_name, '.jpg').titleize
      experience = FactoryGirl.create(:experience, 
        eco: eco, 
        name: experience_name, 
        details: experience_name, 
        image: File.new(image_name),
        comuna: FactoryGirl.build(:santiago), 
        category: FactoryGirl.create(:category, name: 'Entretención')
      )
      # Available to all EFIs
      efis_ids = Efi.pluck(:id)
      efis_ids.each do |efi_id|
        ExperienceEfi.find_or_create_by_efi_id_and_experience_id(efi_id, experience.id)
      end
    end
  end
  
  desc "Load demo data via factories"
  task :factory_data => :environment do
    # Load Industries
    retail = Industry.find_or_create_by_name({name: 'Retail'})
    retail.update_attributes(percentage: 30)
    teleco = Industry.find_or_create_by_name({name: 'Telecomunicaciones'})
    teleco.update_attributes(percentage: 30)
    banca = Industry.find_or_create_by_name({name: 'Banca'})
    banca.update_attributes(percentage: 40)
    
    # Add EFIs
    %w{Falabella Paris Ripley}.each do |efi_name|
      create_efi(efi_name, 'Retail')
    end
    %w{Entel Movistar Claro}.each do |efi_name|
      create_efi(efi_name, 'Telecomunicaciones')
    end
    %w{BCI Santander BBVA}.each do |efi_name|
      create_efi(efi_name, 'Banca')
    end
    
    # Add ECOs with experiences
    ['Cine Hoyts', 'Rip Curl', 'Sushi House', 'Spa Mund', 'Ticketek'].each do |eco_name|
      create_eco(eco_name)
      create_experiences(eco_name)
    end
  end
  
  def efi_purchase(efi_name, experience_name)
    efi = Efi.find_by_name!(efi_name)
    experience = Experience.find_by_name!(experience_name)
    efi_purchase = Event.find_or_initialize_by_efi_id_and_experience_id(efi.id, experience.id)
    efi_purchase.exclusivity_id = 1
    efi_purchase.efi = efi
    efi_purchase.experience = experience
    efi_purchase.exchanges = [Exchange.new(points: 100, cash: 0)] if efi_purchase.exchanges.empty?
    efi_purchase.save!    
  end
  
  desc "Load events"
  task :load_events => :environment do
    efi_purchase('Falabella', 'Cine 2x1')
    efi_purchase('Entel', 'Cine Estreno')
    efi_purchase('BCI', 'Cine Premium')
  end

  def create_efi(name, industry_name)
    industry = Industry.find_by_name!(industry_name)
    efi = FactoryGirl.build(:efinew, name: name)
    efi.industries = [industry]
    efi.save!

    efi_user = FactoryGirl.build(:efi_user, names: name)
    efi_user.efi = efi
    efi_user.save

    10.times do |n|
      client_name = "Cliente #{n}"
      create_clients(client_name, efi)
    end
  end

  def create_clients(name, efi)
    FactoryGirl.create(:client, name: name, efi: efi)
  end

  def create_eco(name)
    eco = FactoryGirl.create(:econew, name: name)

    # FIXME: Admin Group should be the same for all ECOs
    eco_user = FactoryGirl.build(:eco_user, names: name)
    eco_user.eco = eco
    eco_user.save!
  end

  def create_experiences(eco_name)
    eco = Eco.find_by_name!(eco_name)
    eco_folder = eco_name.downcase.gsub(/\s+/, '')
    prices = [[25000, 10000, 10], [50000, 20000, 20], [15000, 5000, 30]]
    Dir.glob(Rails.root.join('db', 'images', 'experiences', eco_folder, '*.jpg')).sort.each_with_index do |image_name, n|
      experience_name = File.basename(image_name, '.jpg').titleize
      experience_prices = prices[n%3]
      experience = FactoryGirl.create(:experience,
        eco: eco,
        name: experience_name,
        details: experience_name,
        image: File.new(image_name),
        comuna: FactoryGirl.build(:santiago),
        category: FactoryGirl.create(:category, name: 'Entretención'),
        amount: experience_prices[0],
        discounted_price: experience_prices[1],
        swaps: experience_prices[2],
        industry_experiences: Industry.all.collect {|i| IndustryExperience.new(industry_id: i.id, percentage: i.percentage)}
      )
      # Available to all EFIs
      efis_ids = Efi.pluck(:id)
      efis_ids.each do |efi_id|
        ExperienceEfi.find_or_create_by_efi_id_and_experience_id(efi_id, experience.id)
      end
    end
  end

  task :factory_girl_env do
    if Rails.env.production?
      Dir.glob(Rails.root.join('spec', 'factories', '*.rb')).each do |factory|
        require factory
      end
    end
  end

  desc "Load demo data via factories"
  task :factory_data => [:environment, :factory_girl_env] do
    # Load Industries
    retail = Industry.find_or_create_by_name({name: 'Retail'})
    retail.update_attributes(percentage: 30)
    teleco = Industry.find_or_create_by_name({name: 'Telecomunicaciones'})
    teleco.update_attributes(percentage: 30)
    banca = Industry.find_or_create_by_name({name: 'Banca'})
    banca.update_attributes(percentage: 40)

    # Add EFIs
    %w{Falabella Paris Ripley}.each do |efi_name|
      create_efi(efi_name, 'Retail')
    end
    %w{Entel Movistar Claro}.each do |efi_name|
      create_efi(efi_name, 'Telecomunicaciones')
    end
    %w{BCI Santander BBVA}.each do |efi_name|
      create_efi(efi_name, 'Banca')
    end

    # Add ECOs with experiences
    ['Cine Hoyts', 'Rip Curl', 'Sushi House', 'Spa Mund', 'Ticketek'].each do |eco_name|
      create_eco(eco_name)
      create_experiences(eco_name)
    end
  end

  def efi_purchase(efi_name, experience_name, opts={})
    efi = Efi.find_by_name!(efi_name)
    experience = Experience.find_by_name!(experience_name)
    efi_purchase = Event.find_or_initialize_by_efi_id_and_experience_id(efi.id, experience.id)
    efi_purchase.exclusivity_id = opts[:exclusivity_id] || 1
    efi_purchase.efi = efi
    efi_purchase.experience = experience
    efi_purchase.exchanges = [Exchange.new(points: 100, cash: 0)] if efi_purchase.exchanges.empty?
    if efi_purchase.exclusivity_id == 2
      efi_purchase.quantity = experience.industry_swaps efi
    elsif efi_purchase.exclusivity_id == 3
      efi_purchase.swaps = opts[:quantity] || experience.swaps
    else
      efi_purchase.quantity = opts[:quantity] || experience.swaps
    end
    p efi_purchase.errors unless efi_purchase.valid?
    efi_purchase.save!
    experience.sell!
  end

  desc "Load events"
  task :load_events => :environment do
    # Exclusividad Total
    efi_purchase('Falabella', 'Cine 2x1')

    experience = Experience.find_by_name!('Cine Estreno')
    experience.income_type ='Canjes'
    experience.save!
    efi_purchase('Entel', 'Cine Estreno')

    experience = Experience.find_by_name!('Cine Premium')
    experience.income_type = 'Validaciones'
    experience.save!
    efi_purchase('BCI', 'Cine Premium')

    # Exclusividad por Industria
    experience = Experience.find_by_name!('Clases De Surf')
    experience.total_exclusivity_days = 0
    experience.update_attributes(total_exclusivity_sales: false, by_industry_exclusivity_sales: true, without_exclusivity_sales: false)
    efi_purchase('Paris', 'Clases De Surf', exclusivity_id: 2, quantity: 0)

    # Sin exclusividad
    experience = Experience.find_by_name!('Spa Y Sauna')
    experience.total_exclusivity_days = 0
    experience.by_industry_exclusivity_days = 0
    experience.update_attributes(total_exclusivity_sales: false, by_industry_exclusivity_sales: false, without_exclusivity_sales: true)
    efi_purchase('Santander', 'Spa Y Sauna', exclusivity_id: 3)

    # Exclusividad por Industria y Sin exclusividad
    experience = Experience.find_by_name!('Colo Colo Vs Universidad De Chile')
    experience.update_attributes(total_exclusivity_sales: false, by_industry_exclusivity_sales: true, without_exclusivity_sales: true)

  end

  desc "Load purchases"
  task :load_purchases => :environment do
    experience = Experience.find_by_name!('Cine Estreno')
    event = Event.find_by_experience_id(experience.id)
    efi = Efi.find_by_name!('Entel')
    clients = efi.accounts.order(:id)
    Purchase.create rut: clients.first.rut, email: 'cliente1@entel.cl', password: 'passC1P1', exchange_id: event.exchanges.first.id
    Purchase.create rut: clients.first.rut, email: 'cliente1@entel.cl', password: 'passC1P2', exchange_id: event.exchanges.first.id
    Purchase.create rut: clients.second.rut, email: 'cliente2@entel.cl', password: 'passC2P1', exchange_id: event.exchanges.first.id
    Purchase.create rut: clients.third.rut, email: 'cliente3@entel.cl', password: 'passC3P1', exchange_id: event.exchanges.first.id

    experience = Experience.find_by_name!('Cine Premium')
    event = Event.find_by_experience_id(experience.id)
    efi = Efi.find_by_name!('BCI')
    clients = efi.accounts.order(:id)
    purchase1 = Purchase.create rut: clients.first.rut, email: 'cliente1@bci.cl', password: 'passC1P1', exchange_id: event.exchanges.first.id
    purchase2 = Purchase.create rut: clients.first.rut, email: 'cliente1@bci.cl', password: 'passC1P2', exchange_id: event.exchanges.first.id
    purchase3 = Purchase.create rut: clients.second.rut, email: 'cliente2@bci.cl', password: 'passC2P1', exchange_id: event.exchanges.first.id
    purchase4 = Purchase.create rut: clients.third.rut, email: 'cliente3@bci.cl', password: 'passC3P1', exchange_id: event.exchanges.first.id

    purchase1.validate!
  end

  desc "Load historical invoices"
  task :load_invoices => :environment do
    eco = Eco.find_by_name!('Ticketek')
    date =
    eco.invoices.create(
      start_at: 1.month.ago.beginning_of_month.to_date,
      end_at: 1.month.ago.end_of_month.to_date,
      state: :paid,
      income: 10000,
      charge: 2000,
      to_pay: 8000
    )
  end

  desc "Load demo data"
  task :load_demo_data => [:environment, :load_efi_users, :load_experiences] do
    puts 'DEMO DATA LOADED!'
  end

  task :load_admin_users do
    puts 'Loading admin users'
    admin = Admin.find_or_create_by_names('Lean Moves')
    admin.update_attributes(
      rut: '15666684-K',
      first_lastname: 'Lean Moves',
      nickname: 'leanmoves',
      email: 'contact@leanmoves.com',
      password: 'leanmoves123',
      password_confirmation: 'leanmoves123'
    )
  end

  task :load_eco_users => :load_eco do
    puts 'Loading ECO users'
    user_eco = UserEco.find_or_create_by_names('Demo')
    user_eco.update_attributes(
      rut: '22971115-6',
      first_lastname: 'ECO',
      nickname: 'user_eco',
      email: 'eco@leanmoves.com',
      password: 'ecoleanmoves123',
      password_confirmation: 'ecoleanmoves123'
    )
    user_eco.groups = [Burlesque::Group.find_or_create_by_name('eco_group')]
    user_eco.roles = [Burlesque::Role.find_or_create_by_name('all#manage')]
    user_eco.eco = Eco.find_by_name('Mund Spa')
    p user_eco.errors unless user_eco.valid?
    user_eco.save!
  end

  task :load_efi_users => :load_efi do
    puts 'Loading EFI users'
    user_efi = UserEfi.find_or_create_by_names('EFI User')
    user_efi.update_attributes(
      rut: '189361823',
      first_lastname: 'EFI lastname',
      second_lastname: 'EFI slastname',
      nickname: 'efiuser',
      email: 'efiuser@leanmoves.com',
      password: 'efiuser123',
      password_confirmation: 'efiuser123',
    )
    user_efi.mod_client = true
    user_efi.efi = Efi.find_by_name('CMR')
    user_efi.save!
  end

  task :load_eco => :load_admin_users do
    puts 'Loading ECO'
    eco = Eco.find_or_initialize_by_name('Mund Spa')
    eco.fancy_name = 'Spa Mund'
    eco.address = 'Cardenal Belarmino 1075'
    eco.comuna = ChileanCities::Comuna.find_by_name('Vitacura')
    eco.discount = 0
    eco.fee = 10
    eco.rut = '85600400-7'
    eco.webpage = 'http://www.spamund.cl'
    eco.logo = File.new Rails.root.join('db', 'images', 'spamund.jpg')
    eco.bigger = true
    eco.admin = Admin.find_by_names('Lean Moves')
    eco.save!
 end

  task :load_efi => :load_industries do
    puts 'Loading EFI'
    efi = Efi.find_or_create_by_name('CMR')
    efi.rut = '77261280-K'
    efi.zona = 'ZONA'
    efi.search_name = 'CMR'
    efi.logo = File.new Rails.root.join('db', 'images', 'cmr.jpg')
    efi.industries = [Industry.find_by_name('Retail')]
    efi.connector_name = 'BaseConnector'
    efi.save!
  end

  task :load_industries do
    puts 'Loading Industries'
    industry = Industry.find_or_create_by_name('Retail')
  end

  task :load_experiences => :load_eco_users do
    puts 'Loading Experiences'
    experience = Experience.find_or_create_by_name('Canjea un Masaje Thai en Spa Mund')
    eco = Eco.find_by_name!('Mund Spa')
    experience.eco_id = eco.id
    experience.save!
  end

end
