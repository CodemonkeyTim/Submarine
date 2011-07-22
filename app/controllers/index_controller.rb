class IndexController < ApplicationController
  
  $jobs_subslists = []
  $list_items_to_show = []
  
  def index
    
    @recent_jobs = $jobs
    
    @items_of_jobs_subs = []
    
    @recent_jobs.each do |i| 
      @items_of_jobs_subs.push([])
    end
              
    @recent_jobs.each_with_index do |i, x|
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
            
      $jobs_subslists.push(@subs_of_a_job) 
      
      @subs_of_a_job.each do
        @items_of_jobs_subs[x].push([])
      end      
      
      @subs_of_a_job.each_with_index do |t, y|
        @items_of_jobs_subs[x][y].push(ListItem.find_all_by_job_number_and_partner_id_and_state(i.job_number, t.id, 1))
        @items_of_jobs_subs[x][y].push(ListItem.find_all_by_job_number_and_partner_id_and_state(i.job_number, t.id, 2))
        @items_of_jobs_subs[x][y].push(ListItem.find_all_by_job_number_and_partner_id_and_state(i.job_number, t.id, 3))
        @items_of_jobs_subs[x][y].push(ListItem.find_all_by_job_number_and_partner_id_and_state(i.job_number, t.id, 4))  
      end             
    end
      
  end

end
