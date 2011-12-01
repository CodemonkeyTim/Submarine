class JobsController < ApplicationController
  
  #Uhm.... How about a bottle of Coke? On me.
  def confirm
    render :layout => nil
  end
  
  #A Background Action
  #Deletes a job with all it's "dependencies"
  def destroy
    @job = Job.find(params[:id])
    
    @job.payment.each do |i|
      i.delete
    end
    
    @job.assignments.each do |i|
      i.documents.each do |j| 
        j.delete
      end
      i.checklist_items.each do |j|
        j.delete
      end
      i.delete
    end
    
    @job.documents.each do |i|
      i.delete
    end
   
    render :nothing => true
  end
  
  #A View Action
  #Pulls the data for the view to show the main page for a job.
  def show    
    @job = Job.find(params[:id])
    
    @assignments = Assignment.find_all_by_job_id(params[:id])
    @asg_loggings = @assignments.collect {|i| i.logs}.flatten
    
    @loggings = @job.logs + @asg_loggings 
    @loggings.sort_by! {|i| i.created_at }
    @loggings.reverse!
    
    #The log_data of each log is stuffed here with formatted log data
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
    
    #The date input's default date, as a formatted string
    @date = Time.now.strftime("%m/%d/%Y")
    
  end
  
  def job_details
    @job = Job.find(params[:id])
    @payment = Payment.find(params[:payment_id])
    
    render :layout => nil
  end
  
  #An Ajax Action
  #Copies the current payments data and creates a new payment with incremented payment number
  #Subs which are with final status in current payment, don't get copied to the new payment
  def new_payment
    @job = Job.find(params[:id])
    @last_payment = Payment.find_all_by_job_id(@job.id, :order => "number").last
    
    #Creating new payment with incremented payment number
    @payment = Payment.create(:number => @last_payment.number+1, :received => false)
    @job.payments.push(@payment)
    
    @last_payment.assignments.each do |i|
      #Passes the assignment (sub/supplier) and does not copy it if it's on final status
      next if i.status == 1
      
      #Copying the assignment, but with new payment id  
      @new_asg = Assignment.create(:job_id => i.job_id, :partner_id => i.partner_id, :parent_id => i.parent_id, :payment_id => @payment.id, :status => i.status, :partner_type => i.partner_type)
      
      #If the assignment was with inactive status, it won't get any checklist items into the new payment
      next if i.status == 3
      
      #But if it regular, all of the checklist items will be copied to next payment 
      @all_items = i.checklist_items
      
      @list_of_items = []
      
      @all_items.each do |j|
        if j.cli_type == 2
          @list_of_items.push(j)
        end
      end 
      
      @list_of_items.each do |i|
        @new_asg.checklist_items.create(:cli_type => 2, :item_data => i.item_data, :state => 3, :sleep_time => 10)
      end
    end
    
    #And log mark from new payment will be added to the job
    @job.logs.create(:target_type => "Payment", :target_name => "##{@payment.number}", :action => "added", :date=> get_date, :time => get_time)
    
    render :text => @payment.id
  end
  
  #An Ajax Action
  #Saves the dates from the payment's payment range fields
  def save_dates
    @job = Job.find(params[:id])
    @payment = Payment.find(params[:payment_id])
    
    #Start and end come in as formatted strings
    @start_year = params[:start][6..9]
    @start_month = params[:start][0..1]
    @start_day = params[:start][3..4]
    
    @end_year = params[:end][6..9]
    @end_month = params[:end][0..1]
    @end_day = params[:end][3..4]
    
    @start_date = Time.new(@start_year, @start_month, @start_day, 12, 0, 0)
    @end_date = Time.new(@end_year, @end_month, @end_day, 12, 0, 0)
    
    #If dates are not valid, server returns an error (Kind of, 306 is an unused status code, 500 would be correct... but the effect is the same here)
    if @end_date < @start_date
      render :status => 306, :nothing => true
    else
      #If dates are ok, they are saved into the payment record
      @payment.range_start = @start_date
      @payment.range_end = @end_date
      @payment.save
      render :nothing => true
    end
  end
  
  #A View Action
  #The landing page of Submarine. Fetches all jobs, sorts them into two arrays according to their state 
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
  
  #A View Action  
  #Project Managers and Project Engineers are pulled to be shown in the dropdown lists
  def new
    @pms = ProjectManager.all
    @pes = ProjectEngineer.all
  end
  
  #A Background action
  #Creates a new job with given params
  def create
    @job = Job.create(:name => params[:name], :job_number => params[:job_number], :location => params[:location], :value => params[:value])
    
    @job_type = ""
    @TU_role = ""
    
    @job.payments.push(Payment.create(:number => 1, :received => false))
    @job.project_manager_id = params[:PM_id]
    @job.project_engineer_id = params[:PE_id]

    @job.save
    
    #"Translates" the numeric info of job type and TU role into words
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
    
    #And a log marking!
    @job.logs.create(:target_type => "Job", :target_name => "#{@job.job_number} / #{@job.name}", :action => "created", :date=> get_date, :time => get_time)
  end
  
  def touch_all
    
    
  end
  
  #A View Action
  def edit
    @job = Job.find(params[:id])
    
    @taggys = @job.tags.all
    @tags = @taggys.collect {|i| i.tag_name}.flatten
    
    @pms = ProjectManager.all
    @pes = ProjectEngineer.all
  end
  
  #A Background Action
  #Updates the job with given data
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
