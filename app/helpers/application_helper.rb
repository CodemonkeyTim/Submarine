module ApplicationHelper
  
  $partners = Partner.find(:all)
  $jobs = Job.find(:all)
  $subcontractors = Partner.find_all_by_partner_type(1)
  $suppliers = Partner.find_all_by_partner_type(2)
  
  $active_tab = 2;
  
  def title 
    base_title = "Submarine"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
    
  end
        
  def locate
    
    
     
  end
  
  def am_i_active_tab (t)
    if t == $active_tab
      "active"
    else
      "non-active"
    end      
  end
  
end
