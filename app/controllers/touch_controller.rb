class TouchController < ApplicationController
  def touch 
    @t = params[:id]
    @item = ListItem.find(@t)
    @item.touched_at = Time.now
    @item.save
  end
  
  def touch_all 
    
    
    
  end
  
  
end
