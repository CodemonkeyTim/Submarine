module JobHelper
  
  def get_jobs
    @jobs_as_list = []
    
    @closed_job_numbers = []
    @open_job_numbers = []
    
    @jobs = Job.find(:all)
    
    @jobs.each do |i|
      @items = ListItem.find_all_by_job_number(i.job_number)
      @im_done = true
      @items.each do |t|
        if t.state != 4
          @im_done = false
          break
        end          
      end
      
      if @im_done
        @closed_job_numbers.push(i.job_number)
      else
        @open_job_numbers.push(i.job_number)
      end
    end
    
    @jobs_as_list.push(Job.find_all_by_job_number(@open_job_numbers))
    @jobs_as_list.push(Job.find_all_by_job_number(@closed_job_numbers))
    
    return @jobs_as_list
        
  end
   
  def get_items (i, t)
    @items = ListItem.find_all_by_partner_id_and_job_number(i, t)
    return @items    
  end
end
