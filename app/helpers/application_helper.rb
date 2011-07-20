module ApplicationHelper
  
  $partners = Partner.find(:all)
  $jobs = Job.find(:all)
  $subcontractors = Partner.find_all_by_partner_type(1)
  $suppliers = Partner.find_all_by_partner_type(2)
  $list_items = ListItem.find(:all)
  
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
  
  def get_stylesheets
    @sheets = ["layout_style.css"]
    
    if $active_tab == 1
      @sheets.push("index_style.css")
    end
    if $active_tab == 2
      @sheets.push("jobs_style.css")
    end  
    if $active_tab == 3
      @sheets.push("vendors_style.css")
    end  
    if $active_tab == 4
      @sheets.push("to_do_style.css")
    end
    
    return @sheets
  
  end
  
end
