class Adjustment < ActiveRecord::Base
  belongs_to  :order
  composed_of :amount, :class_name  => 'Money',
                       :mapping     => [ %w( amount_in_cents cents ), %w( currency currency_as_string ) ],
                       :constructor => Proc.new { |cents, currency| Money.new( cents || 0, currency || Money.default_currency ) },
                       :converter   => Proc.new { |value| value.respond_to?( :to_money ) ? value.to_money : 0.to_money }

  validates_presence_of     :order, :amount
end