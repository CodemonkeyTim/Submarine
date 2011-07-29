class JobsController < ApplicationController
  def show    
    @job = Job.find_by_job_number(params[:id])
    
    #Following block reads from log file and stores loggings into an array.
    @log = []
    
    File.open("/home/codemonkey/rails/Submarine/log/history_logs/job#{@job.job_number}.log", 'r') do |i|
      while line = i.gets
        @log.push(line)
      end
    end
    
    @job.subcontractors.each do |i|
      i.state = (i.checklist_items.collect {|j| j.state} + i.suppliers.collect {|j| j.checklist_items.collect {|k| k.state}}).flatten.sort!.first
      if i.state.nil?
        i.state = 4
      end
    end
  
  end
    
  def index
    @jobs = Job.find(:all)
        
    @jobs.each do |l| 
      l.state = (l.subcontractors.collect {|i| i.checklist_items.collect {|j| j.state} + i.suppliers.collect {|j| j.checklist_items.collect {|k| k.state}}}).flatten.sort!.first
      if l.state.nil?
        l.state = 4
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
    @job.save
    
    Job.find_by_job_number(params[:job_number]).logs.push(Log.new(:log_data => "Job created at #{Time.now}", :log_level => 1))
    
    #File.open("/home/codemonkey/rails/Submarine/log/history_logs/job#{@job.job_number}.log", 'w') do |i|
    #  i.write("Job created at #{Time.now}")
    #end
    
  end
  
  def touch_all
    
    
  end
  
  def history
    
    
  end
  
  def fade
    @id = params[:id]
    
    
    
  end
end
