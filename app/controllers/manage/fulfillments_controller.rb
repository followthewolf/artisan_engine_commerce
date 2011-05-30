module Manage
  class FulfillmentsController < Manage::BackController
    belongs_to :order
  end
end