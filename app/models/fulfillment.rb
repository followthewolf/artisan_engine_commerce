class Fulfillment < ActiveRecord::Base
  belongs_to :order
  has_many   :line_items
  
  composed_of               :cost, :class_name  => 'Money',
                                   :mapping     => [ %w( cost_in_cents cents ), %w( currency currency_as_string ) ],
                                   :constructor => Proc.new { |cents, currency| Money.new( cents || 0, currency || Money.default_currency ) },
                                   :converter   => Proc.new { |value| value.respond_to?( :to_money ) ? value.to_money : 0.to_money }
end