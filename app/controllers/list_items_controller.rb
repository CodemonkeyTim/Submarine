class ListItemsController < ApplicationController
  def new
    @name = params[:name]          
    @job_id = params[:job_id]
    @payment_id = params[:payment_id]
    @partner_id = params[:partner_id]
    @parent_id = params[:parent_id]
    @partner_type = params[:partner_type]
  end

  def create
    @asg = Assignment.find_by_job_id_and_parent_id_and_partner_id_and_partner_type_and_payment_id(params[:job_id], params[:parent_id], params[:partner_id], params[:partner_type], params[:payment_id])
    @asg.checklist_items.create(:item_data => params[:item_data], :state => 3, :sleep_time => 10, :cli_type => params[:repeatable_type])    
    @asg.logs.create(:target_type => "Item", :target_name => "#{params[:item_data]}", :action => "added", :time => get_time, :date => get_date)
    
    @page_to_return_to = ""
    
    if @asg.partner_type == 1
      @page_to_return_to = "/subcontractors/#{@asg.partner_id}?job_id=#{@asg.job_id}&parent_id=#{@asg.parent_id}"
    else
      @page_to_return_to = "/suppliers/#{@asg.partner_id}?job_id=#{@asg.job_id}&subcontractor_id=#{@asg.parent_id}"
    end  
  end

  def show
  end

  def index
    
    #All items categorized by state
    @overdue_items = []
    @open_items = [] 
    @waiting_items = [] 
    @completed_items = []   
    
    @jobs = Job.all
    
    @jobs.each do |i|
      @items = i.checklist_items
      
      @items.each do |j|
        if j.state == 1
          @overdue_items.push(j)
        end
        if j.state == 2
          @open_items.push(j)
        end
        if j.state == 3
          @waiting_items.push(j)
        end
        if j.state == 4
          @completed_items.push(j)
        end
      end
      
    end    
    
  end

end
