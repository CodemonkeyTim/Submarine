class JobsController < ApplicationController
  def show    
    @job = Job.find(params[:id])
    
    @log = @job.log_markings
      
  end
    
  def index
    @jobs = Job.all            
  end
    
  
  def new
    @job = Job.new
    @subcontractors = Subcontractor.all
    @suppliers = Supplier.all
    @checklist_items = ChecklistItem.all

  end
  
  def create
    @job = Job.new
    @job.name = params[:name]
    @job.job_number = params[:job_number]
    @job.location = params[:location]
    @job.value = params[:value]
    @job.save
    
    Job.find_by_job_number(params[:job_number]).logs.push(Log.new(:log_data => "Job created at #{Time.now}", :log_level => 1))
    
    File.open("/home/codemonkey/rails/Submarine/log/history_logs/job#{@job.job_number}.log", 'w') do |i|
      i.write("Job created at #{Time.now}")
    end
    
  end
  
  def touch_all
    
    
  end
  
  def history
    
    
  end
  
  def fade
    @id = params[:id]
    
    
    
  end
end
