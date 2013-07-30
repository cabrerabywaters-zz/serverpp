class AddConditionsAndExchangeMechanismToExperiences < ActiveRecord::Migration
  def change
    add_column :experiences, :conditions, :text
    add_column :experiences, :exchange_mechanism_id, :integer
  end
end
