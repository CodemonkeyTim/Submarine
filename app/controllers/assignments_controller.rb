class AssignmentsController < ApplicationController
  
  #Gathers all information to be shown on "Assign a Sub" or "Assign a Supplier" pages
  
  def new  
    @partners = Partner.find(:all, :order => "name")
    @partners.delete_if {|i| i.id == params[:parent_id]}
    
    @payment_id = params[:payment_id]
    @super_parent_id = params[:super_parent_id]
    @parent_id = params[:parent_id]
    @job = Job.find(params[:job_id])
    @partner_type = params[:partner_type]
    
    if params[:parent_id] == "0"
      @title_text = "Assign subcontractor to #{@job.job_number} / #{@job.name}"
    else
      if params[:partner_type] == "1"
        @what_to_assign = "subcontractor"
        @target_name = Partner.find(params[:parent_id]).name
        @title_text = "Assign #{@what_to_assign} to #{@target_name}"
      end
      if params[:partner_type] == "2"
        @what_to_assign = "supplier"
        @target_name = Partner.find(params[:parent_id]).name
        @title_text = "Assign #{@what_to_assign} to #{@target_name}"
      end
    end 
    
  end

  def create
    @super_parent_id = params[:super_parent_id]
    
    @asg = Assignment.create(:job_id => params[:job_id], :parent_id => params[:parent_id], :partner_id => params[:partner_id], :partner_type => params[:partner_type], :status => 3, :payment_id => params[:payment_id])
    if params[:partner_type] == 1
      @target_type = "Subcontractor"
    end
    if params[:partner_type] == 2
      @target_type = "Supplier"
    end
    
    @target_name = Partner.find(params[:partner_id]).name
    
    @job = Job.find(params[:job_id])
    @job.logs.create(:target_type => @target_type, :target_name => @target_name, :action => "assigned", :time => get_time, :date => get_date) 
    
    if params[:parent_id] == "0"
      @where_to = "/jobs/#{@job.id}"
    else
      @where_to = "/subcontractors/#{params[:parent_id]}?job_id=#{@job.id}&parent_id=#{params[:super_parent_id]}"
    end
    
    render "create.js.erb"
  end
  
  def create_and_assign
    @partner = Partner.create(:name => params[:partner_name])
     
    @partner.contact_person = ContactPerson.create(:name =>params[:cp_name], :title => params[:cp_title], :phone_number => params[:cp_phone_number], :email => params[:cp_email])
    @partner.address = Address.create(:street => params[:addrs_street], :zip_code => params[:addrs_zip_code], :city => params[:addrs_city], :state => params[:addrs_state])  
    
    @super_parent_id = params[:super_parent_id]
    
    @asg = Assignment.create(:job_id => params[:job_id], :parent_id => params[:parent_id], :partner_id => @partner.id, :partner_type => params[:partner_type], :status => 3)
    if params[:partner_type] == 1
      @target_type = "Subcontractor"
    end
    if params[:partner_type] == 2
      @target_type = "Supplier"
    end
    
    @target_name = @partner.name
    
    @job = Job.find(params[:job_id])
    @job.logs.create(:target_type => @target_type, :target_name => @target_name, :action => "assigned", :time => get_time, :date => get_date) 
    
    @tags = @job.tags.collect {|i| i.tag_name } 
    
    @list_of_items = []
    
    if @asg.partner_type == 1
      @list_of_items.push(ListItemTemplate.find_all_by_item_type(3))
      if @tags.include?("Public") 
        @list_of_items.push(ListItemTemplate.find_all_by_item_type(1))
      end
      if @tags.include?("Private") 
       @list_of_items.push(ListItemTemplate.find_all_by_item_type(2))
      end
    end
    if @asg.partner_type == 2
      @list_of_items.push(ListItemTemplate.find(5))
      @list_of_items.push(ListItemTemplate.find(8))
    end

    @list_of_items.flatten!
    
    @list_of_items.each do |i|
      @asg.checklist_items.create(:cli_type => i.rep_type, :item_data => i.item_data, :state => 3, :sleep_time => 10, :touched_at => (Time.now + 16000000000))
    end
    
    if params[:parent_id] == "0"
      @where_to = "/jobs/#{@job.id}"
    else
      @where_to = "/subcontractors/#{params[:parent_id]}?job_id=#{@job.id}&parent_id=#{params[:super_parent_id]}"
    end
    
    render "create_and_assign.js.erb"
    
  end
end
