class JobsController < ApplicationController
  def show    
    @job = Job.find(params[:id])
    
    @log = @job.logs
      
  end
    
  def index
    @jobs = Job.all
    
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
    
    @job.logs.create(:log_data => "Job created at #{Time.now}")
    
    @job.save
  end
  
  def touch_all
    
    
  end
  
  def history
    
    
  end
  
  def fade
    @id = params[:id]
    
    
    
  end
end
