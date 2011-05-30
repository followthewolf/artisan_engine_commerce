class OrdersController < FrontController
  before_filter :load_current_order
  
  # GET /order
  def new
  end
  
  # GET /checkout
  def edit
    @shipping_address = Address.new
    @billing_address  = Address.new
  end
  
  # POST /checkout
  def update
    @shipping_address = @order.shipping_address = Address.new( params[ :shipping_address ] )
    @billing_address  = @order.billing_address  = Address.new( params[ :shipping_is_billing ] ? params[ :shipping_address ] : params[ :billing_address ] )
    @billing_errors   = params[ :shipping_is_billing ] ? false : true
    
    if @order.update_attributes( params[ :order ] )
      @order.checkout! ? redirect_to( paypal_path ) : render( :edit )
    else
      render :edit
    end
  end
  
  # GET /paypal
  def paypal
  end
  
  # GET /update_state_select
  def update_state_select
    @country_code = params[ :country ]
    @type         = params[ :type ]
  end
  
  private
  
    def load_current_order
      @order = current_order
    end
end