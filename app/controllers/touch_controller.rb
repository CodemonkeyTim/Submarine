class TouchController < ApplicationController
  def touch 
    @t = params[:id]
    @item = ListItem.find(@t)
    @item.touched_at = Time.now
    @item.save
  end
  
  def touch_all
    @job_number = params[:id]
    @items = ListItem.find_all_by_job_number(@job_number)
    
    @items.each do |i| 
      i.touched_at = Time.now.utc
      i.state = 2
      i.save      
    end
    
  end
  
  
end
