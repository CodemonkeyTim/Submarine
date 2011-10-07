class AssignmentsController < ApplicationController
  
  #Gathers all information to be shown on "Assign a Sub" or "Assign a Supplier" pages
  
  def new  
    @payment_id = params[:payment_id]
    @super_parent_id = params[:super_parent_id]
    @parent_id = params[:parent_id]
    @job = Job.find(params[:job_id])
    @partner_type = params[:partner_type]
    
    @partners = Partner.find(:all, :order => "name")
    @assigned_ids = Assignment.find_all_by_job_id_and_parent_id_and_payment_id(@job.id, @parent_id, @payment_id).collect {|i| i.partner_id}.uniq
    @assigned_ids.each do |i|
      @partners.delete_if {|j| j.id == i}
    end
    @partners.delete_if {|i| i.id == params[:parent_id].to_i}
    
    
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
    
    @asg = Assignment.create(:job_id => params[:job_id], :parent_id => params[:parent_id], :partner_id => @partner.id, :partner_type => params[:partner_type], :status => 3, :payment_id => params[:payment_id])
    if params[:partner_type] == 1
      @target_type = "Subcontractor"
    end
    if params[:partner_type] == 2
      @target_type = "Supplier"
    end
    
    @target_name = @partner.name
    
    @job = Job.find(params[:job_id])
    @job.logs.create(:target_type => @target_type, :target_name => @target_name, :action => "assigned", :time => get_time, :date => get_date) 
    
    if params[:parent_id] == "0"
      @where_to = "/jobs/#{@job.id}"
    else
      @where_to = "/subcontractors/#{params[:parent_id]}?job_id=#{@job.id}&parent_id=#{params[:super_parent_id]}"
    end
    
    render "create_and_assign.js.erb"
    
  end
end
