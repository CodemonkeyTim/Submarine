class IndexController < ApplicationController
  
  $jobs_subslists = []
  $list_items_to_show = []
  
  def index
    @recent_jobs = Job.all
    
    @recent_jobs.each do |l| 
      l.state = (l.subcontractors.collect {|i| i.checklist_items.collect {|j| j.state} + i.suppliers.collect {|j| j.checklist_items.collect {|k| k.state}}}).flatten.sort!.first
      if l.state.nil?
        l.state = 4
      end
      
      l.subcontractors.each do |i| 
        i.state = (i.checklist_items.collect {|j| j.state} + i.suppliers.collect {|j| j.checklist_items.collect {|k| k.state}}).flatten.sort!.first
        if i.state.nil?
          i.state = 4
        end
        
        i.suppliers.each do |j| 
          j.state = (j.checklist_items.collect {|j| i.state}).flatten.sort!.first
          if j.state.nil?
            j.state = 4
          end
        end      
      end
    end
    
    @overdue_items = ChecklistItem.find_all_by_state(1, :order => "touched_at")
    
    @overdue_amounts = []
    
    @overdue_items.each do |i|
      @overdue_amounts.push(((Time.now.utc - i.touched_at)/86400).to_i)      
    end
    
  end

end
