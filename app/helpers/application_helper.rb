module ApplicationHelper
  
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
  
end
