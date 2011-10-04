class JobsController < ApplicationController
  def show    
    @job = Job.find(params[:id])
    
    @assignments = Assignment.find_all_by_job_id(params[:id])
    @asg_loggings = @assignments.collect {|i| i.logs}.flatten
    
    @loggings = @job.logs + @asg_loggings 
    @loggings.sort_by! {|i| i.created_at }
    @loggings.reverse!
    
    @loggings.each do |i|
      if i.loggable_type == "Assignment"
        @id = Assignment.find(i.loggable_id).partner_id
        @partner = Partner.find(@id)
        i.log_data = "#{@partner.name}: #{i.target_type} #{i.target_name} #{i.action}#{unless i.notes.nil? then ", #{i.notes}" end} on #{i.date} at #{i.time}"
      else
        i.log_data = "Job: #{i.target_type} #{i.target_name} #{i.action}#{unless i.notes.nil? then ", #{i.notes}" end} on #{i.date} at #{i.time}"
      end
    end
    
    @log = @loggings[(0..3)]
    
    #@date: used for submitting date for method which save the payments received to DB
    # so that as default date in the input field is date today.
    
    @date = Time.now.strftime("%m/%d/%Y")
    
  end
  
  def job_details
    @job = Job.find(params[:id])
    @payment = Payment.find(params[:payment_id])
    
    render :layout => nil
  end
  
  def new_payment
    @job = Job.find(params[:id])
    @last_payment = Payment.find_all_by_job_id(@job.id, :order => "number").last
    
    @payment = Payment.create(:number => @last_payment.number+1, :received => false)
    @job.payments.push(@payment)
    
    @tags = @job.tags.collect {|i| i.tag_name } 
    
    @public_and_private = ListItemTemplate.find_all_by_item_type(3)
    @public = ListItemTemplate.find_all_by_item_type(1)
    @private = ListItemTemplate.find_all_by_item_type(2)
    @supplier_items = ListItemTemplate.find([6, 10])
    
    @last_payment.assignments.each do |i|
      next if i.status == 1
        
      @new_asg = Assignment.create(:job_id => i.job_id, :partner_id => i.partner_id, :parent_id => i.parent_id, :payment_id => @payment.id, :status => i.status, :partner_type => i.partner_type)
      
      next if i.status == 3
      
      @list_of_items = []
      
      if @new_asg.partner_type == 1
        @list_of_items.push(@public_and_private)
        if @tags.include?("Public") 
          @list_of_items.push(@public)
        end
        if @tags.include?("Private") 
         @list_of_items.push(@private)
        end
      end
      if @new_asg.partner_type == 2
        @list_of_items.push(@supplier_items)
      end
  
      @list_of_items.flatten!
      
      @list_of_items.each do |i|
        if i.rep_type == 2 
          @new_asg.checklist_items.create(:cli_type => i.rep_type, :item_data => i.item_data, :state => 3, :sleep_time => 10)
        end
      end
    end
    
    render :text => @payment.id
  end
    
  def index
    @jobs = Job.find(:all, :order => "name")
    
    @open_jobs = []
    @closed_jobs = []
    
    @jobs.each do |i|
      if i.state == 4
        @closed_jobs.push(i)
      else
        @open_jobs.push(i)
      end
    end  
              
  end
    
  
  def new
    @pms = ProjectManager.all
    @pes = ProjectEngineer.all
  end
  
  def create

    @job = Job.create(:name => params[:name], :job_number => params[:job_number], :location => params[:location], :value => params[:value])
    
    @job_type = ""
    @TU_role = ""
    
    @job.payments.push(Payment.create(:number => 1, :received => false))
    @job.project_manager_id = params[:PM_id]
    @job.project_engineer_id = params[:PE_id]

    @job.save
    
    if params[:job_type] == "1"
      @job_type = "Public"
    end
    if params[:job_type] == "2"
      @job_type = "Private"
    end
    if params[:TU_role] == "1"
      @TU_role = "Prime"
    end
    if params[:TU_role] == "2"
      @TU_role = "Sub" 
    end
    
    @job.tags.create(:tag_name => @job_type)
    @job.tags.create(:tag_name => @TU_role)
    
    @job.logs.create(:target_type => "Job", :target_name => "#{@job.job_number} / #{@job.name}", :action => "created", :date=> get_date, :time => get_time)
  end
  
  def touch_all
    
    
  end
  
  def edit
    @job = Job.find(params[:id])
    
    @taggys = @job.tags.all
    @tags = @taggys.collect {|i| i.tag_name}.flatten
    
    @pms = ProjectManager.all
    @pes = ProjectEngineer.all
  end
  
  def update
    @job = Job.find(params[:id])
    @job.name = params[:name]
    @job.job_number = params[:job_number]
    @job.location = params[:location]
    @job.value = params[:value]
    @job.project_manager_id = params[:PM_id]
    @job.project_engineer_id = params[:PE_id]
    
    @job.tags.each {|i| i.delete }
    
    @job.tags.create(:tag_name => params[:job_type])
    @job.tags.create(:tag_name => params[:TU_role])
    
    @job.save
    
  end
  
end
