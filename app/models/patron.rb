class Patron < ActiveRecord::Base
  has_many :addresses
  
  validates_presence_of :first_name, :last_name, :email
  validates_format_of   :email, :with => /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
end