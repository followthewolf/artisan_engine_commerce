class LineItemsController < FrontController
  def create
    good_id          = params[ :line_item ][ :good_id ]
    option_value_ids = params[ :option_value_ids ] || []
    
    variant = Variant.find_by_good_and_option_values( good_id, option_value_ids )
    
    @line_item = current_order.new_line_item_from( variant )
    @line_item.save
    
    redirect_to new_order_path
  end
  
  update! do |success, failure|
    success.html { redirect_to new_order_path }
  end
  
  destroy! do |success, failure|
    success.html { redirect_to new_order_path }
  end
  
  def update_all
    params[ :line_item ].each do |key, value|
      LineItem.find( key ).update_attributes( :quantity => value )
    end
    
    redirect_to new_order_path
  end
end