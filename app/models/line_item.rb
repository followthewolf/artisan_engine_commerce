class LineItem < ActiveRecord::Base
  belongs_to  :order
  
  validates_presence_of     :order, :name, :sku, :quantity
  validates_numericality_of :price, 
                              :greater_than_or_equal_to => 1
  
  composed_of :price, 
                :class_name  => 'Money',
                :mapping     => [ %w( price_in_cents cents ), %w( currency currency_as_string ) ],
                :constructor => Proc.new { |cents, currency| Money.new( cents || 0, currency || Money.default_currency ) },
                :converter   => Proc.new { |value| value.respond_to?( :to_money ) ? value.to_money : 0.to_money }
end