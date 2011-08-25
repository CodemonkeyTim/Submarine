class ControlsController < ApplicationController
  def touch_this 
    @t = params[:id]
    @item = ListItem.find(@t)
    @item.state = 2

    @item.save
  end
  
  def touch_all
    @job = Job.find(params[:id])
    @items = @job.active_checklist_items
    
    @asgs = Assignment.find_all_by_job_id(@job.id)
    
    @asgs.each do |i|
      i.checklist_items.each do |j|
        @items.each do |k|
          if j.id == k.id 
            k.status = i.status
          end
        end
      end
    end
    
    @date = params[:date]
    
    @month = @date[0,2]
    @day = @date[3,2]
    @year = @date[6,4]
    
    @date_to_save = Time.new(@year.to_i, @month.to_i, @day.to_i, 12, 0, 0, "-08:00")
    
    @items.each do |i|
      if i.cli_type == 2 || (i.cli_type == 3 && i.status == 1)
        if Time.now.utc - @date_to_save.utc > (i.sleep_time * 86400)
          i.state = 1
        else
          i.state = 2
        end
        
        i.touched_at = @date_to_save.utc
        i.save

      end
    end
    
    if @job.subcontractors.length == 0
      @job.logs.create(:target_type => "Payment (received: #{@month}/#{@day}/#{@year})", :target_name => "", :action => "marked received", :notes => "no subcontractors present", :time => get_time, :date => get_date)
    else  
      @job.logs.create(:target_type => "Payment (received: #{@month}/#{@day}/#{@year})", :target_name => "", :action => " marked received", :time => get_time, :date => get_date)  
    end
    
    @log = @job.logs.last
    @log.log_data = "Job: #{@log.target_type} #{@log.target_name} #{@log.action}#{unless @log.notes.nil? then ", #{@log.notes}" end} on #{@log.date} at #{@log.time}"
    
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
    @cli.touched_at = @cli.touched_at + 16000000000
    @cli.save
    
    @asg = Assignment.find(@cli.assignment_id)
    @asg.logs.create(:target_type => "Item", :target_name => @cli.item_data, :action => "marked done", :time => get_time, :date => get_date)
    
    @log = @asg.logs.last
    @partner_name = Partner.find(@asg.partner_id).name
    @log_data = "#{@partner_name}: #{@log.target_type} #{@log.target_name} #{@log.action}#{unless @log.notes.nil? then ", #{@log.notes}" end} on #{@log.date} at #{@log.time}"
    if @log_data.include?('\'')
      @log_data = @log_data.gsub('\'', '\\')
    end

  end
  
  def undo
    @cli = ChecklistItem.find(params[:item_id])
    @cli.state = params[:state]
    @cli.touched_at = @cli.touched_at - 16000000000
    @cli.save
    @id = @cli.id
    
    @state = ""
    if @cli.state == 1
      @state = "overdues" 
    end
    if @cli.state == 2 
      @state = "opens" 
    end
    if @cli.state == 3
      @state = "waitings"
    end
    if @cli.state == 4 
      @state = "completeds" 
    end
    
    if @cli.state == 1
      @state_name = "overdue"
    else
      @state_name = "open"
    end
  
    @asg = Assignment.find(@cli.assignment_id)
    @asg.logs.create(:target_type => "Item", :target_name => @cli.item_data, :action => "corrected", :time => get_time, :date => get_date)
    
  end
  
  def show_fields
    
    
  end
   
  def change_status 
    @asg = Assignment.find(params[:asg_id])
    @asg.status = params[:status]
    @asg.save
     
    if params[:status] == "1" 
      @asg.checklist_items.each do |i|
        if i.cli_type == 3
          i.state = 2
          i.save
        end
       end
      end
     
     @partner_id = @asg.partner_id
  end
    
end