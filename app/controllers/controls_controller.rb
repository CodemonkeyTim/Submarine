class ControlsController < ApplicationController
  
  #An Ajax Action
  #Marks the payment received, changes the statuses of all of the ChecklistItems in the subs/suppliers in the given payment
  def payment_received
    #Date comes in as a formatted string which is then broken down into parts and then supplied for Ruby Time object
    @day = params[:date][2..3]
    @month = params[:date][0..1]
    @year = params[:date][4..7]
    @date = Time.new(@year.to_i, @month.to_i, @day.to_i, 12, 0, 0)
    
    #DB handles stuff in UTC so we have to do so too
    @time = @date.utc
    @job = Job.find(params[:id])
    @payment = Payment.find(params[:payment_id])
    
    #Payment is marked to be received and on the given date
    @payment.received = true
    @payment.received_on = @time
    @payment.overdue_on = @time + 864000 #864000 seconds == 10 days
    @payment.save
    
    #Retrieves all Assignment records in this job and in this payment
    @asgs = Assignment.find_all_by_job_id_and_payment_id(@job.id, @payment.id)
    
    #Assigns the ChecklistItem's status according to the Assignment's status it belongs to 
    @items = []
    @asgs.each do |i|
      i.checklist_items.each do |j|
        j.status = i.status
        @items.push(j)
      end
    end
    
    #If the overdue date has already passed, the items are set overdue right away given that the items are either regular or final
    if Time.now > @payment.overdue_on
      @items.each do |i|
        # Three statements connected with or which have to result in true to change ChecklistItem's state into overdue
        # 1. Item repeat type is repeating and status is either regular or final
        # 2. Item repeat type is initial and status is either regular or final
        # 3. Item repeat type is final and status is final
        if (i.cli_type == 2 && (i.status == 2 || i.status == 1)) || (i.cli_type == 1 && (i.status == 2 || i.status == 1)) || (i.cli_type == 3 && i.status == 1)
          i.state = 1
          i.save
        end
      end
    else
      #If the payment is not overdue, but following conditions are met, ChecklistItems are set to "open" state
      @items.each do |i|
        #Same conditions as above
        if (i.cli_type == 2 && (i.status == 2 || i.status == 1)) || (i.cli_type == 1 && (i.status == 2 || i.status == 1)) || (i.cli_type == 3 && i.status == 1)
          i.state = 2
          i.save
        end
      end
    end
    
    #If there is no subcontractors in the current payment, log marking will be slightly different
    if @job.subcontractors(@payment.id).length == 0
      @job.logs.create(:target_type => "Payment ##{@payment.number}", :target_name => "", :action => "marked received", :notes => "no subcontractors present", :time => get_time, :date => get_date)
    else
      @job.logs.create(:target_type => "Payment ##{@payment.number})", :target_name => "", :action => " marked received", :time => get_time, :date => get_date)
    end

    #Log model's non-persistent log_data variable is used here for showing data in the view
    @log = @job.logs.last
    @log.log_data = "Job: #{@log.target_type} #{@log.target_name} #{@log.action}#{unless @log.notes.nil? then ", #{@log.notes}" end} on #{@log.date} at #{@log.time}"
  end

  #An Ajax Action
  #Finds ChecklistItem record with given id and deletes it
  def delete_item
    @cli = ChecklistItem.find(params[:id])
    @cli.delete
    render :nothing => true
  end
  
  #Marks a single ChecklistItem to be done.
  def mark_done
    @id = params[:id]
    @cli = ChecklistItem.find(@id)
    @cli.state = 4
    @cli.save
    
    #Creates a log mark
    @asg = Assignment.find(@cli.assignment_id)
    @asg.logs.create(:target_type => "Item", :target_name => @cli.item_data, :action => "marked done", :time => get_time, :date => get_date)
    
    #returns a string in same format as log marking is in the DB to append this to the logs box
    @log = @asg.logs.last
    @partner_name = Partner.find(@asg.partner_id).name
    @log_data = "#{@partner_name}: #{@log.target_type} #{@log.target_name} #{@log.action}#{unless @log.notes.nil? then ", #{@log.notes}" end} on #{@log.date} at #{@log.time}"
    if @log_data.include?('\'')
      @log_data = @log_data.gsub('\'', '\\')
    end
  end
  
  #An Ajax Action
  #Marks a ChecklistItem record into it's former state which is provided in the params
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
  
  #Uhh... Can't remember...
  def show_fields

  end
    
  #An Ajax Action
  #Changes the status of an Assignment record (in other words sub's/supplier's status)
  def change_status
    @payment = Payment.find(params[:payment_id])

    @asg = Assignment.find(params[:asg_id])
    @partner_id = @asg.partner_id
    
    #If there is payments for this sub in this job, then the initial items will not be added to the assignments later in this action
    @former_payments = Assignment.find_all_by_job_id_and_partner_id_and_partner_type_and_parent_id_and_status(@asg.job_id, @asg.partner_id, 1, @asg.parent_id, 2).collect {|i| i.payment }.flatten

    #The assignments under this assignment (in given payment) are gathered so the status change will affect them as well
    @asgs = @asg.assignments(@payment.id)
    @asgs.push(@asg)
    
    #The status which assignments are changed to is "converted" into words for Log record
    if params[:status] != "3" || (@asg.status != 3 && params[:status] == "3")
      @status_with_words = ""
      if params[:status] == "1"
        @status_with_words = "final"
      end
      if params[:status] == "2"
        @status_with_words = "reg"
      end
      if params[:status] == "3"
        @status_with_words = "inactive"
      end
      
      #Log marking to the assingment's log is created
      @asg.logs.create(:target_name => Partner.find(@asg.partner_id).name, :action => "status changed to #{@status_with_words}", :time => get_time, :date => get_date)

      @job = Job.find(@payment.job_id)
      @tags = @job.tags.collect {|i| i.tag_name }
      
      #Because it is very likely that the sub/supplier itself doesn't yet have any checklist items
      # as it might have been inactive, the template items are pulled from DB to be used later on with
      # subs/suppliers without items.
      @public_and_private = ListItemTemplate.find_all_by_item_type(3)
      @public = ListItemTemplate.find_all_by_item_type(1)
      @private = ListItemTemplate.find_all_by_item_type(2)
      @supplier_items = ListItemTemplate.find([6, 10])
      
      #For each assignment, relevant checklist items are created 
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
        
        #No more template checklist items will be added if the assignment already has some checklist items created from templates
        #Assignment might have some custom checklist items which are not cared of 
        if i.template_checklist_items_length == 0
          @list_of_items.each do |j|
            if @former_payments.length == 0 && j.rep_type == 1
              i.checklist_items.create(:cli_type => j.rep_type, :item_data => j.item_data, :state => 3, :sleep_time => 10)
            else
              if j.rep_type == 2
                i.checklist_items.create(:cli_type => j.rep_type, :item_data => j.item_data, :state => 3, :sleep_time => 10)
              end
            end
          end
        else
          #If there already are checklist items but the status is set to be final, final checklist items have to be added
          if params[:status] == "1"
            @add_finals = true
            
            #On the other hand, if there already is even one final type checklist item, it indicates
            # that sub has been turned to final once before already and no duplicates should be created
            i.checklist_items.each do |j|
              if j.cli_type == 3
                @add_finals = false
              end
            end
          end
          #The final type items are attached to assignment here
          if @add_finals
            @list_of_items.each do |j|
              if j.rep_type == 3
                i.checklist_items.create(:cli_type => j.rep_type, :item_data => j.item_data, :state => 3, :sleep_time => 10)
              end
            end
          end
        end
      end
      
      #If the current payment user is on, has already been received, the new checklist items created just a moment
      # ago are now given correct state.
      if @payment.received?
        @asgs.each do |i|
          i.status = params[:status]
          i.checklist_items.each do |j|
            unless j.state == 4
              #if status that assignment is being changed to is regular and
              # the checklist item in question is of initial type, it will be opened, 
              # as overdue if payment is overdue, as open if not.
              if params[:status] == "2" && j.cli_type == 1
                if (Time.now.utc - @payment.received_on) > 864000
                  j.state = 1
                else
                  j.state = 2
                end
              end
              
              #Same, except the condition is that if status is to be regular and the
              # type of checklist item is repeating
              if params[:status] == "2" && j.cli_type == 2
                if (Time.now.utc - @payment.received_on) > 864000
                  j.state = 1
                else
                  j.state = 2
                end
              else
                #In other case, if status is to be final and checklist items repeatable type is not initial
                # it will be opened
                if params[:status] == "1" && j.cli_type > 1
                  if Time.now.utc - @payment.received_on > 864000
                    j.state = 1
                  else
                    j.state = 2
                  end
                end
              end
            j.save
            end
            i.save
          end
        end
      else
        @asgs.each do |i|
          i.status = params[:status]
          i.save
        end
      end
    end
  end
  
  #An Ajax Action
  #Does what it says, deletes the assignment and it's with given id
  def delete_assignment
    @asg = Assignment.find(params[:id])
    
    #All the "nested" assignemnts are pulled as well.
    @asgs = Assignment.find_all_by_job_id_and_partner_id_and_partner_type_and_parent_id(@asg.job_id, @asg.partner_id, @asg.partner_type, @asg.parent_id)

    @job = Job.find(@asg.job_id)
    @partner = Partner.find(@asg.partner_id)
    
    #Collects all assignments in all of the payments in the job
    @asgs.each do |i|
      @job.payments.each do |j|
        i.assignments(j.id).each do |k|
          @asgs.push(k)
        end
      end
    end
    
    #D-E-L-E-T-E-!
    @asgs.each do |i|
      i.delete
    end
    
    #Creating log mark
    @job.logs.create(:target_type => "Subcontractor", :target_name => @partner.name, :action => "removed", :time => get_time, :date => get_date)

    render :nothing => true
  end

end