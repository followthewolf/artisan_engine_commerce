module Manage
  class OrdersController < Manage::BackController
    def index
      @orders = Order.where( "status != 'new'" ).all
    end
  end
end