class ControlsController < ApplicationController
  def touch_this 
    @t = params[:id]
    @item = ListItem.find(@t)
    @item.state = 2

    @item.save
  end
  
  def touch_all
    @job = Job.find(params[:id])
    @items = @job.checklist_items
        
    @items.each do |i|
      if i.cli_type == 1
        i.state = 2
        i.touched_at = Time.now.utc
        i.save
      end
    end
    
    @job.logs.create(:target_type => "Payment", :target_name => "", :action => "received", :time => get_time, :date => get_date)
    
  end
  
  def modify
    @t = params[:id]
    @i = params[:action_id]
    
    @item = ListItem.find(@t)
    @former_state = @item.state
    
    @items_state_with_words = ""
    @former_state_with_words = ""
    
    if @i == 1
      @item.state = 2
      @items_state_with_words = "open"
      @item.touched_at = Time.now.utc
      @item.save
    end
    if @i == 2
      @item.state = 3
      @items_state_with_words = "waiting"
      @item.save
    end
    #if @i == 1
    #  @item.state = 2
    #  @items_state_with_words = "waiting"
    #  @item.touched_at = Time.now.utc
    #  @item.save
    #end
    #if @i == 1
    #  @item.state = 2
    #  @items_state_with_words = "waiting"
    #  @item.touched_at = Time.now.utc
    #  @item.save
    #end
    
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
  
  def mark_done
    @id = params[:id]
    @cli = ChecklistItem.find(@id)
    @cli.state = 3
    @cli.touched_at = Time.now.utc + 16000000000
    
    @asg = Assignment.find(@cli.assignment_id)
    @asg.logs.create(:target_type => "Item", :target_name => @cli.item_data, :action => "marked done", :time => get_time, :date => get_date)
    
    @cli.save
  end
  
    
end
