module OrdersHelper
  def current_order
    if session[ :order_id ]
      order = Order.find( session[ :order_id ] )
      return order if order.new? || order.pending?
    end      
  
    new_order            = Order.create!
    session[ :order_id ] = new_order.id
    new_order
  end
end