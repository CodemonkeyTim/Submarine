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
        i.log_data = "#{@partner.name}: #{i.log_data}"
      end
    end
    
    @log = @loggings[(0..3)]
      
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

  end
  
  def create
    @job = Job.create(:name => params[:name], :job_number => params[:job_number], :location => params[:location], :value => params[:value])
    
    @job.logs.create(:log_data => "Job created at #{get_time}")
  end
  
  def touch_all
    
    
  end
  
  def history
    
    
  end
  
  def fade
    @id = params[:id]
    
    
    
  end
end
