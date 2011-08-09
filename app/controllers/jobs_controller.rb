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
    
    @job_type = ""
    @TU_role = ""
    
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
    
    @job.logs.create(:target_type => "Job", :target_name => "#{@job.job_number} / #{@job.name}", :action => "created", :date=> get_date, :time => get_date)
  end
  
  def touch_all
    
    
  end
  
  def fade
    @id = params[:id]
    
    
    
  end
end
