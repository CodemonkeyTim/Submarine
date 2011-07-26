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
    
  
  end
    
  def index
    @jobs = Job.find(:all)
        
    @jobs.each do |l| 
      l.state = (l.subcontractors.collect {|i| i.checklist_items.collect {|j| j.state} + i.suppliers.collect {|j| j.checklist_items.collect {|k| k.state}}}).flatten.sort!.first
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
  
  def fade
    @id = params[:id]
    
    
    
  end
end
