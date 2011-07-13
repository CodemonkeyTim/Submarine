class JobController < ApplicationController
  def show
    @job = Job.find_by_job_number(params[:id])
    @partnerIds = JobPartner.find_all_by_job_number(@job.job_number)
    @partners = Partner.find(@partnerIds)
  end
  
  def job
  end

end
