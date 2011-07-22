class ControlsController < ApplicationController
  def touch_this 
    @t = params[:id]
    @item = ListItem.find(@t)
    @item.state = 2
    @item.touched_at = Time.now.utc
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
  
  def modify
    @t = params[:id]
    @i = params[:action_id]
    
    @item = ListItem.find(@t)
    
    @former_state = 3
    
    @item.state = 3
    @items_state_with_words = "waiting"
    
    @item.save
    
    @former_state_with_words = ""
    
    if @former_state == 1
      @former_state_with_words = "overdue"
    end
    if @former_state == 2
      @former_state_with_words = "open"
    end
    if @former_state == 3
      @former_state_with_words = "waiting"
    end
    if @former_state == 4
      @former_state_with_words = "completed"
    end
    
    
    
  end  
end
