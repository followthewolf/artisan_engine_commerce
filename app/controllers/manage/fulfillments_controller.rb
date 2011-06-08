module Manage
  class FulfillmentsController < Manage::BackController
    belongs_to :order
    
    create! do |success, failure|
      success.html do
        OrderMailer.fulfillment_email( @fulfillment.order.patron, @fulfillment ).deliver
        redirect_to manage_order_path( @fulfillment.order )
      end
    end
  end
end