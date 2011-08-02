class IndexController < ApplicationController
  
  def index
    @recent_jobs = Job.all
    
    @overdue_items = ChecklistItem.find_all_by_state(1, :order => "touched_at")
    
    @overdue_amounts = []
    
    @overdue_items.each do |i|
      @overdue_amounts.push(((Time.now.utc - i.touched_at)/86400).to_i)
    end
  end
end
