# encoding: utf-8

Category.create(name: 'Fútbol',     texture_name: Category::TEXTURES.first, icon: File.new(Rails.root + 'spec/fixtures/categories/futbol.ico'))
Category.create(name: 'Conciertos', texture_name: Category::TEXTURES.first, icon: File.new(Rails.root + 'spec/fixtures/categories/conciertos.ico'))
Category.create(name: 'Teatros',    texture_name: Category::TEXTURES.first, icon: File.new(Rails.root + 'spec/fixtures/categories/teatros.ico'))
Category.create(name: 'Restaurant', texture_name: Category::TEXTURES.first, icon: File.new(Rails.root + 'spec/fixtures/categories/restaurant.ico'))
Category.create(name: 'Viajes',     texture_name: Category::TEXTURES.first, icon: File.new(Rails.root + 'spec/fixtures/categories/viajes.ico'))