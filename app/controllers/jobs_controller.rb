class JobsController < ApplicationController
  def show
    @job = Job.find_by_job_number(params[:id])
    @partner_data = JobPartner.find_all_by_job_number(@job.job_number)
    @partner_ids = []
    
    @partner_data.each do |i| 
      @partner_ids.push(i.partner_id)
    end
    
    @partner_amount = Partner.find(:all).length
    
    @subcontractors = []
    
    @partner_ids.each do |i|
      @subcontractors.push(Partner.find(i))
    end
        
    @all_subcontractors = Partner.find_all_by_partner_type(1)
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
end
