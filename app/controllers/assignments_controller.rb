class AssignmentsController < ApplicationController
  
  #A View Action
  #Gathers all information for the assigning view (Assigning subs/suppliers to sub/job)
  def new  
    #Following code block would usually be needless, but I tended to do it anyways
    #The values gotten as params are stored into variables for handier handling
    @payment_id = params[:payment_id]
    @super_parent_id = params[:super_parent_id]
    @parent_id = params[:parent_id]
    @job = Job.find(params[:job_id])
    @partner_type = params[:partner_type]
    
    #Retrieves from DB all of the Partner records for the dropdown list in the view
    @partners = Partner.find(:all, :order => "name")
    
    #Gathers all the ids of such partners who are already assigned to this sub/job in this payment
    @assigned_ids = Assignment.find_all_by_job_id_and_parent_id_and_payment_id(@job.id, @parent_id, @payment_id).collect {|i| i.partner_id}.uniq
    
    #All such partners are deleted (and thus won't be shown) from the collection of Partner records 
    # because we don't want a sub/supplier to be assigned twice
    @assigned_ids.each do |i|
      @partners.delete_if {|j| j.id == i}
    end
    @partners.delete_if {|i| i.id == params[:parent_id].to_i}
    
    #Parent id 0 means that we are assigning a sub to a job
    if params[:parent_id] == "0"
      @title_text = "Assign subcontractor to #{@job.job_number} / #{@job.name}"
    else
      #In other cases the user is assgning sub/supplier to a sub
      if params[:partner_type] == "1"
        #User is assigning a sub
        @what_to_assign = "subcontractor"
        #Into this sub
        @target_name = Partner.find(params[:parent_id]).name
        #And this combines the indormation and is used in the view
        @title_text = "Assign #{@what_to_assign} to #{@target_name}"
      end
      #Same things for supplier
      if params[:partner_type] == "2"
        @what_to_assign = "supplier"
        @target_name = Partner.find(params[:parent_id]).name
        @title_text = "Assign #{@what_to_assign} to #{@target_name}"
      end
    end 
    
  end
  
  #A Background Action
  #Creates an assignment record which links a sub/supplier with sub/job according to the data 
  # from the previous view (Assigning subs/suppliers to sub/job)
  def create
    #Super parent id is the "parent of the parent" 's id
    @super_parent_id = params[:super_parent_id]
    @payment = Payment.find(params[:payment_id])
    @job = Job.find(params[:job_id])
    
    #If parent id is 0, it means user is assigning a sub to a job but in other cases a sub/supplier to a sub
    unless params[:parent_id] == "0"
      #Parent assignment record links the parent sub into it's parent sub or job
      @parent_asg = Assignment.find_by_job_id_and_parent_id_and_partner_id_and_partner_type_and_payment_id(params[:job_id], params[:super_parent_id], params[:parent_id], 1, params[:payment_id])
      @asg = Assignment.create(:job_id => params[:job_id], :parent_id => params[:parent_id], :partner_id => params[:partner_id], :partner_type => params[:partner_type], :status => @parent_asg.status, :payment_id => params[:payment_id])
      
      #Following code blocks create and attach the basic ChecklistItem records into the new assignment 
      @tags = @job.tags.collect {|i| i.tag_name }
      
      #Gathers from DB certaing types of ListItemTemplate records
      @public_and_private = ListItemTemplate.find_all_by_item_type(3)
      @public = ListItemTemplate.find_all_by_item_type(1)
      @private = ListItemTemplate.find_all_by_item_type(2)
      @supplier_items = ListItemTemplate.find([6, 10])
      
      #The array where to the correct ListItemTemplate records are collected
      @list_of_items = []
      
      if @asg.partner_type == 1
        @list_of_items.push(@public_and_private)
        if @tags.include?("Public")
          @list_of_items.push(@public)
        end
        if @tags.include?("Private")
          @list_of_items.push(@private)
        end
      end
      if @asg.partner_type == 2
        @list_of_items.push(@supplier_items)
      end
      
      @list_of_items.flatten!
      
      #If the parent sub is inactive, no ChecklistItem records are created
      #If the parent sub is "open", which mean that it is on regular or final status, all the regular items are attached the new assignment
      if @parent_asg.status == 2 || @parent_asg.status == 1
        @list_of_items.each do |j|
          if j.rep_type == 2
            #Creates ChecklistItems according to the template
            @asg.checklist_items.create(:cli_type => j.rep_type, :item_data => j.item_data, :state => 3, :sleep_time => 10)
          end
        end
      end
      
      #If the parent sub has final status, the new assignment is also attached the final ChecklistItems
      if @parent_asg.status == 1
        @list_of_items.each do |j|
          if j.rep_type == 3
            @asg.checklist_items.create(:cli_type => j.rep_type, :item_data => j.item_data, :state => 3, :sleep_time => 10)
          end
        end
      end
      
      #If the payment has already been received by the time sub is assigned, the state of the checklist items is set open
      # unless the overdue date has been passed, which means the state is set to overdue
      if @payment.received?
        if Time.now > @payment.overdue_on
          @asg.checklist_items.each do |i|
            i.state = 1
            i.save
          end
        else
          @asg.checklist_items.each do |i|
            i.state = 2
            i.save
          end
        end
      end
    else
      #Creates an Assignment record which links a sub into a job in a payment
      @asg = Assignment.create(:job_id => params[:job_id], :parent_id => params[:parent_id], :partner_id => params[:partner_id], :partner_type => params[:partner_type], :status => 3, :payment_id => params[:payment_id])
    end
    
    #Partner type "converted" into words for the Log record
    if params[:partner_type] == 1
      @target_type = "Subcontractor"
    end
    if params[:partner_type] == 2
      @target_type = "Supplier"
    end
    
    @target_name = Partner.find(params[:partner_id]).name
    
    @job.logs.create(:target_type => @target_type, :target_name => @target_name, :action => "assigned", :time => get_time, :date => get_date) 
    
    #Forms the url where browser is redirected
    if params[:parent_id] == "0"
      @where_to = "/jobs/#{@job.id}?payment_id=#{@payment.id}"
    else
      @where_to = "/subcontractors/#{params[:parent_id]}?job_id=#{@job.id}&parent_id=#{params[:super_parent_id]}&payment_id=#{@payment.id}"
    end
    
    render "create.js.erb"
  end
  
  #A Background Action
  #Creates a new partner record and then does the same as previous action 
  def create_and_assign
    @partner = Partner.create(:name => params[:partner_name])
    
    #Creates a new ContactPerson and Address records and links it with the new Partner record 
    @partner.contact_person = ContactPerson.create(:name =>params[:cp_name], :title => params[:cp_title], :phone_number => params[:cp_phone_number], :email => params[:cp_email])
    @partner.address = Address.create(:street => params[:addrs_street], :zip_code => params[:addrs_zip_code], :city => params[:addrs_city], :state => params[:addrs_state])  
    
    #Super parent means the "parent of the parent".
    @super_parent_id = params[:super_parent_id]
    
    @asg = Assignment.create(:job_id => params[:job_id], :parent_id => params[:parent_id], :partner_id => @partner.id, :partner_type => params[:partner_type], :status => 3, :payment_id => params[:payment_id])
    
    #The type is "converted" into string for the Log record
    if params[:partner_type] == 1
      @target_type = "Subcontractor"
    end
    if params[:partner_type] == 2
      @target_type = "Supplier"
    end
    
    #Log marking of sub/sup assignment is created and linked to job
    @job = Job.find(params[:job_id])
    @job.logs.create(:target_type => @target_type, :target_name => @partner_name, :action => "assigned", :time => get_time, :date => get_date) 
    
    #Forms the url where page is redirected by script in the rendered .js.erb
    if params[:parent_id] == "0"
      @where_to = "/jobs/#{@job.id}?payment_id=#{@payment.id}"
    else
      @where_to = "/subcontractors/#{params[:parent_id]}?job_id=#{@job.id}&parent_id=#{params[:super_parent_id]}&payment_id=#{@payment.id}"
    end
    
    render "create_and_assign.js.erb"
    
  end
end
