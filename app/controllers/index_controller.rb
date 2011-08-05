class IndexController < ApplicationController
  
  def index   
    @recent_jobs_rows = RecentJobs.find(:all, :order => "created_at").reverse!
    
    @recent_jobs = []
    
    @recent_jobs.push(Job.find(@recent_jobs_rows[0].job_id))
    @recent_jobs.push(Job.find(@recent_jobs_rows[1].job_id))
    @recent_jobs.push(Job.find(@recent_jobs_rows[2].job_id))
    
    @overdue_items = ChecklistItem.find_all_by_state(1, :order => "touched_at").reverse
    @overdue_items = @overdue_items[(0..3)]
    
    @overdue_amounts = []
    
    @overdue_items.each do |i|
      @overdue_amounts.push(((Time.now.utc - i.touched_at)/86400).to_i)
    end
  end
end
