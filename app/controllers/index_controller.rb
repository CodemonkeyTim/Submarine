class IndexController < ApplicationController
  
  $jobs_subslists = []
  
  def index
    @recent_jobs = $jobs
            
    @recent_jobs.each do |i|
      @subs_ids = []
      
      @partner_data_of_a_job = JobPartner.find_all_by_job_number(i.job_number)
      @partner_data_of_a_job.each do |t|
        @subs_ids.push(t.partner_id)  
      end
      
      @subs_of_a_job = []
      
      @subs_ids.each do |t|
        @partner = Partner.find(t)
        @subs_of_a_job.push(@partner)
      end
      
      #@subs_of_a_job = Partner.find_all_by_id(@subs_ids)            
      
      $jobs_subslists.push(@subs_of_a_job)  
    end
  end

end
