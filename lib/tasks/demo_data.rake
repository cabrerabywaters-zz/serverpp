namespace :app do

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
