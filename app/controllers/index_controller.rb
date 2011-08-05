class IndexController < ApplicationController
  
  def index
    @jobs = Job.all
    
    @logs = @jobs.collect {|i| i.logs} + Assignment.all.collect {|i| i.logs}
    @logs.flatten!
    
    @logs.sort_by! {|i| i.created_at}
    @logs = @logs.uniq {|i| i.loggable_id}
    @ids = @logs.collect {|i| i.loggable_id}
    @ids = @ids[(0..2)]
    
    @recent_jobs = Job.find_all_by_id(@ids)
    
    @overdue_items = ChecklistItem.find_all_by_state(1, :order => "touched_at").reverse
    @overdue_items = @overdue_items[(0..3)]
    
    @overdue_amounts = []
    
    @overdue_items.each do |i|
      @overdue_amounts.push(((Time.now.utc - i.touched_at)/86400).to_i)
    end
  end
end
