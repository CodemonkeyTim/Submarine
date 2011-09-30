class IndexController < ApplicationController
  
  def index   
    refresh_states
    @recent_jobs_rows = RecentJobs.find(:all, :order => "created_at").reverse!
    
    @recent_jobs = []
    
    unless @recent_jobs_rows.first.nil?
      @recent_jobs_rows.each do |i|
        @recent_jobs.push(Job.find(i.job_id))  
      end  
    end
    
    @overdue_items = ChecklistItem.find_all_by_state(1, :order => "touched_at").reverse
    @overdue_items = @overdue_items[(0..3)]
    
    @overdue_amounts = []
    
    @overdue_items.each do |i|
      @overdue_amounts.push(((Time.now.utc - i.touched_at)/86400).to_i)
    end
    
    
    
    
  end
end
