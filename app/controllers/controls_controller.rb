class ControlsController < ApplicationController
  def touch_this 
    @t = params[:id]
    @item = ListItem.find(@t)
    @item.state = 2

    @item.save
  end
  
  def payment_received
    @time = Time.now.utc
    @job = Job.find(params[:id])
    @payment = Payment.find(params[:payment_id])
    
    @payment.received = true
    @payment.received_on = @time
    @payment.save
    
    @asgs = Assignment.find_all_by_job_id_and_payment_id(@job.id, @payment.id)
    
    @items = []
    @asgs.each do |i|
      i.checklist_items.each do |j|
        j.status = i.status
        @items.push(j)
      end
    end
    
    @items.each do |i|
      if (i.cli_type == 2 && (i.status == 2 || i.status == 1)) || (i.cli_type == 3 && i.status == 1)
        i.state = 2
        i.save
      end
    end
    
    
    if @job.subcontractors(@payment.id).length == 0
      @job.logs.create(:target_type => "Payment (received: #{@time.strftime("%m/%d/%Y")})", :target_name => "", :action => "marked received", :notes => "no subcontractors present", :time => get_time, :date => get_date)
    else  
      @job.logs.create(:target_type => "Payment (received: #{@time.strftime("%m/%d/%Y")})", :target_name => "", :action => " marked received", :time => get_time, :date => get_date)  
    end
    
    @log = @job.logs.last
    @log.log_data = "Job: #{@log.target_type} #{@log.target_name} #{@log.action}#{unless @log.notes.nil? then ", #{@log.notes}" end} on #{@log.date} at #{@log.time}"
    
    @payment.received = true
    @payment.save
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
    @cli.state = 4
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
    @payment = Payment.find(params[:payment_id])
    
    @asg = Assignment.find(params[:asg_id])
    @partner_id = @asg.partner_id
    
    @former_payments = Assignment.find_all_by_job_id_and_partner_id_and_partner_type_and_parent_id(@asg.job_id, @asg.partner_id, 1, @asg.parent_id).collect {|i| i.payment }.flatten
    
    @asgs = @asg.assignments(@payment.id)
    @asgs.push(@asg)
    
    if params[:status] != "3"
      @job = Job.find(@payment.job_id)
      @tags = @job.tags.collect {|i| i.tag_name }
      
      @public_and_private = ListItemTemplate.find_all_by_item_type(3)
      @public = ListItemTemplate.find_all_by_item_type(1)
      @private = ListItemTemplate.find_all_by_item_type(2)
      @supplier_items = ListItemTemplate.find([6, 10])
      
      @asgs.each do |i|
        i.status = params[:status]
        
        @list_of_items = []
        
        if i.partner_type == 1
          @list_of_items.push(@public_and_private)
          if @tags.include?("Public") 
            @list_of_items.push(@public)
          end
          if @tags.include?("Private") 
            @list_of_items.push(@private)
          end
        end
        if i.partner_type == 2
          @list_of_items.push(@supplier_items)
        end
        
        @list_of_items.flatten!
        
        if i.checklist_items.length == 0
          
          @list_of_items.each do |j|
            if @former_payments.length == 1 && j.rep_type == 1
              i.checklist_items.create(:cli_type => j.rep_type, :item_data => j.item_data, :state => 3, :sleep_time => 10)
            else
              if j.rep_type == 2
                i.checklist_items.create(:cli_type => j.rep_type, :item_data => j.item_data, :state => 3, :sleep_time => 10)
              end
            end
          end
        else
          if params[:status] == "1"
            @add_finals = true
          
            i.checklist_items.each do |j|
              if j.cli_type == 3
                @add_finals = false
              end
            end  
          end
          if @add_finals
            @list_of_items.each do |j|
              if j.rep_type == 3
                i.checklist_items.create(:cli_type => j.rep_type, :item_data => j.item_data, :state => 3, :sleep_time => 10)
              end
            end
          end
        end
      end
      
      if @payment.received?
        @asgs.each do |i|
          i.checklist_items.each do |j|
            unless j.state == 4
              j.status == params[:status]
                if params[:status] == "2" && j.cli_type == 1
                  if (Time.now.utc - @payment.received_on) > 86400
                    j.state = 1
                  else
                    j.state = 2
                  end
                end
                if params[:status] == "2" && j.cli_type == 2
                  if (Time.now.utc - @payment.received_on) > 86400
                    j.state = 1
                  else
                    j.state = 2
                  end
                else
                  if params[:status] == "1" && j.cli_type > 1
                    if Time.now.utc - @payment.received_on > 86400
                      j.state = 1
                    else
                      j.state = 2
                    end
                  end
                end
                j.save
              end
            end
          i.save
        end
      end
    end
  end
  
end