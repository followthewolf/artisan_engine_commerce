class Address < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :address1, :city, :country, :postal_code
end