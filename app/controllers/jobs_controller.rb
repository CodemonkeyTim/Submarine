class JobsController < ApplicationController
  def show
    #---------------------------------------------------------------------#
    # Fetches from DB all the  important data to be used in show.html.erb #
    #---------------------------------------------------------------------#
    
    #Current jobs data is needed so it's fetched from DB
    @job = Job.find_by_job_number(params[:id])
    
    #Partner data includes ids of all partners of this job. We want 'em.
    @partner_data = JobPartner.find_all_by_job_number(@job.job_number)
    @partner_ids = []
    
    #Partner ids are pushed to a var
    @partner_data.each do |i| 
      @partner_ids.push(i.partner_id)
    end
    
    #Subcontractors of this job are stored to this var
    @subcontractors = Partner.find_all_by_id(@partner_ids)
        
    #Consists of all subcontractors in DB
    @all_subcontractors = Partner.find_all_by_partner_type(1)
    
    #--------------------------------------------------------------------#
    
    #these will be used to show job history
    @items = ListItem.find_by_job_number(@job.job_number, :order => "touched_at")
    
    #Following block reads from log file and stores loggings into an array.
    @log = []
    
    File.open("/home/codemonkey/rails/Submarine/log/history_logs/job#{@job.job_number}.log", 'r') do |i|
      while line = i.gets
        @log.push(line)
      end
    end
    
  
  end
    
  def index
    @jobs = Job.find(:all)
    @job_items = []
    @completed_jobs = []
    @uncompleted_jobs = []    
    
    @jobs.each do |i|
      
      @completed = true
      
      @job_items = ListItem.find_all_by_job_number(i.job_number)
      
      @job_items.each do |i|
        if i.state != 3
          @completed = false
        end
      end
      
      if @completed 
        @completed_jobs.push(i)
      else
        @uncompleted_jobs.push(i)    
      end    
    end  
  end
  
  def new

  end
  
  def create
    @data = []
    @data.push(params[:number])
    @data.push(params[:name])
    @data.push(params[:PM_id])
    @data.push(params[:location])
    @data.push(params[:value]) 
    
    @job = Job.new({:job_number => @data[0], :name => @data[1], :PM_id => @data[2], :location => @data[3], :value => @data[4]})
    @job.save
  end
  
  def touch_all
    
    
  end
  
  def history
    
    
  end
end
