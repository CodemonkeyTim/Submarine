module JobHelper
  
  def get_jobs
    @items = ListItem.find(:all)
    
    @jobs_as_list = []
    
    @open_job_ids = []
    @closed_job_ids = []
    
    @items.each do |i|
      if i.state != 4
        @open_job_ids.push(i.partner_id)
      else
        @closed_job_ids.push(i.partner_id)
      end
    end
    
    @jobs_as_list.push(Job.find_all_by_id(@open_job_ids))
    @jobs_as_list.push(Job.find_all_by_id(@closed_job_ids))
    
    return @jobs_as_list
        
  end
   
end
