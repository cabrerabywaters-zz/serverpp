# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131022155851) do

  create_table "accounts", :force => true do |t|
    t.integer  "efi_id"
    t.integer  "points"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "rut"
    t.string   "name"
    t.string   "password"
  end

  add_index "accounts", ["efi_id"], :name => "index_accounts_on_efi_id"

  create_table "admins", :force => true do |t|
    t.string   "rut"
    t.string   "names"
    t.string   "first_lastname"
    t.string   "second_lastname"
    t.string   "nickname"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "advertisings", :force => true do |t|
    t.string   "name"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "banners", :force => true do |t|
    t.integer  "event_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "published"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "banners", ["event_id"], :name => "index_banners_on_event_id"

  create_table "burlesque_admin_groups", :force => true do |t|
    t.integer  "group_id"
    t.integer  "adminable_id"
    t.string   "adminable_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "burlesque_admin_groups", ["adminable_id", "adminable_type"], :name => "by_adminable"
  add_index "burlesque_admin_groups", ["group_id"], :name => "index_burlesque_admin_groups_on_group_id"

  create_table "burlesque_admin_roles", :force => true do |t|
    t.integer  "role_id"
    t.integer  "authorizable_id"
    t.string   "authorizable_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "burlesque_admin_roles", ["authorizable_id", "authorizable_type"], :name => "by_authorizable"
  add_index "burlesque_admin_roles", ["role_id"], :name => "index_burlesque_admin_roles_on_role_id"

  create_table "burlesque_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "burlesque_role_groups", :force => true do |t|
    t.integer  "role_id"
    t.integer  "group_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "burlesque_role_groups", ["group_id"], :name => "index_burlesque_role_groups_on_group_id"
  add_index "burlesque_role_groups", ["role_id"], :name => "index_burlesque_role_groups_on_role_id"

  create_table "burlesque_roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.string   "texture_name"
  end

  create_table "chilean_cities_comunas", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "provincia"
    t.string   "region"
    t.string   "region_number"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "ecos", :force => true do |t|
    t.string   "name"
    t.string   "rut"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "webpage"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.boolean  "images"
    t.string   "fancy_name"
    t.string   "address"
    t.float    "discount"
    t.float    "fee"
    t.integer  "comuna_id"
    t.integer  "admin_id"
    t.text     "description"
    t.boolean  "bigger"
  end

  add_index "ecos", ["admin_id"], :name => "index_ecos_on_admin_id"
  add_index "ecos", ["comuna_id"], :name => "index_ecos_on_comuna_id"
  add_index "ecos", ["rut"], :name => "index_ecos_on_rut"

  create_table "efis", :force => true do |t|
    t.string   "rut"
    t.string   "name"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "zona"
    t.string   "search_name"
    t.string   "connector_name"
    t.boolean  "compared"
    t.string   "api_username"
    t.string   "api_password"
  end

  add_index "efis", ["rut"], :name => "index_efis_on_rut"
  add_index "efis", ["search_name"], :name => "index_efis_on_search_name"

  create_table "events", :force => true do |t|
    t.integer  "quantity"
    t.integer  "swaps"
    t.integer  "exclusivity_id"
    t.integer  "efi_id"
    t.integer  "experience_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "state"
  end

  add_index "events", ["efi_id"], :name => "index_events_on_efi_id"
  add_index "events", ["exclusivity_id"], :name => "index_events_on_exclusivity_id"
  add_index "events", ["experience_id"], :name => "index_events_on_experience_id"

  create_table "exchanges", :force => true do |t|
    t.integer  "points"
    t.integer  "cash"
    t.integer  "event_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "exchanges", ["event_id"], :name => "index_exchanges_on_event_id"

  create_table "experience_advertisings", :force => true do |t|
    t.integer  "experience_id"
    t.integer  "advertising_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "experience_advertisings", ["advertising_id"], :name => "index_experience_advertisings_on_advertising_id"
  add_index "experience_advertisings", ["experience_id"], :name => "index_experience_advertisings_on_experience_id"

  create_table "experience_efis", :force => true do |t|
    t.integer  "experience_id"
    t.integer  "efi_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "experience_efis", ["efi_id"], :name => "index_experience_efis_on_efi_id"
  add_index "experience_efis", ["experience_id"], :name => "index_experience_efis_on_experience_id"

  create_table "experiences", :force => true do |t|
    t.string   "name"
    t.text     "details"
    t.integer  "amount"
    t.string   "place"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.date     "starting_at"
    t.date     "ending_at"
    t.integer  "swaps"
    t.integer  "eco_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "category_id"
    t.text     "summary"
    t.date     "validity_starting_at"
    t.date     "validity_ending_at"
    t.integer  "discounted_price"
    t.text     "codes"
    t.integer  "chilean_cities_comuna_id"
    t.string   "state"
    t.text     "conditions"
    t.text     "exchange_mechanism"
    t.integer  "codes_by_purchase"
    t.float    "fee"
    t.boolean  "total_exclusivity_sales"
    t.boolean  "by_industry_exclusivity_sales"
    t.boolean  "without_exclusivity_sales"
    t.integer  "total_exclusivity_days"
    t.integer  "by_industry_exclusivity_days"
    t.integer  "without_exclusivity_days"
  end

  add_index "experiences", ["category_id"], :name => "index_experiences_on_category_id"
  add_index "experiences", ["chilean_cities_comuna_id"], :name => "index_experiences_on_chilean_cities_comuna_id"
  add_index "experiences", ["eco_id"], :name => "index_experiences_on_eco_id"

  create_table "industries", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.float    "percentage"
  end

  create_table "industry_efis", :force => true do |t|
    t.integer  "industry_id"
    t.integer  "efi_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "industry_efis", ["efi_id"], :name => "index_industry_efis_on_efi_id"
  add_index "industry_efis", ["industry_id"], :name => "index_industry_efis_on_industry_id"

  create_table "industry_experiences", :force => true do |t|
    t.integer  "industry_id"
    t.integer  "experience_id"
    t.float    "percentage"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "industry_experiences", ["experience_id"], :name => "index_industry_experiences_on_experience_id"
  add_index "industry_experiences", ["industry_id"], :name => "index_industry_experiences_on_industry_id"

  create_table "interest_experiences", :force => true do |t|
    t.integer  "interest_id"
    t.integer  "experience_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "interest_experiences", ["experience_id"], :name => "index_interest_experiences_on_experience_id"
  add_index "interest_experiences", ["interest_id"], :name => "index_interest_experiences_on_interest_id"

  create_table "interests", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "publicities", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "comment"
    t.string   "state"
    t.integer  "event_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "publicities", ["event_id"], :name => "index_publicities_on_event_id"

  create_table "purchases", :force => true do |t|
    t.integer  "exchange_id"
    t.string   "rut"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "code"
    t.string   "reference_code"
    t.string   "state"
    t.text     "reference_codes"
  end

  add_index "purchases", ["exchange_id"], :name => "index_purchases_on_exchange_id"

  create_table "transactions", :force => true do |t|
    t.integer  "operation_id"
    t.integer  "points"
    t.integer  "account_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "transactions", ["account_id"], :name => "index_transactions_on_account_id"

  create_table "user_ecos", :force => true do |t|
    t.string   "rut"
    t.string   "names"
    t.string   "first_lastname"
    t.string   "second_lastname"
    t.string   "nickname"
    t.integer  "eco_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "user_ecos", ["eco_id"], :name => "index_user_ecos_on_eco_id"
  add_index "user_ecos", ["email"], :name => "index_user_ecos_on_email", :unique => true
  add_index "user_ecos", ["reset_password_token"], :name => "index_user_ecos_on_reset_password_token", :unique => true

  create_table "user_efis", :force => true do |t|
    t.string   "rut"
    t.string   "names"
    t.string   "first_lastname"
    t.string   "second_lastname"
    t.string   "nickname"
    t.integer  "efi_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "mod_client"
  end

  add_index "user_efis", ["efi_id"], :name => "index_user_efis_on_efi_id"
  add_index "user_efis", ["email"], :name => "index_user_efis_on_email", :unique => true
  add_index "user_efis", ["reset_password_token"], :name => "index_user_efis_on_reset_password_token", :unique => true
  add_index "user_efis", ["rut"], :name => "index_user_efis_on_rut"

  create_table "valid_images", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "experience_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "valid_images", ["experience_id"], :name => "index_valid_images_on_experience_id"

end
