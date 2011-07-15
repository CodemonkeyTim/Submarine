class JobController < ApplicationController
  def show
    @job = Job.find_by_job_number(params[:id])
    @partnerIds = JobPartner.find_all_by_job_number(@job.job_number)
    @subcontractors = Partner.find(@partnerIds)
  end
  
  def job
    
    
  end
  
  def index
    
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
