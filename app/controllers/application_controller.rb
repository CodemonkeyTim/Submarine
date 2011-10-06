class ApplicationController < ActionController::Base
  protect_from_forgery   
  
  
  #Returns current time as string in hh:mm am/pm format
  def get_time
    
    @hour = Time.now.hour
    @amorpm = "am"
    
    if @hour > 12
      @hour =  @hour-12
      @amorpm = "pm"
    end
    
    @minute = Time.now.min
    
    if @minute < 10
      @minute = "0#{@minute}"
    end
    
    @time  = "#{@hour}:#{@minute} #{@amorpm}"
  end
  
  #Returns current date as string in format as in following example Jan 13, 2011
  def get_date
    @abbs = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
    @date = "#{@abbs[Time.now.mon-1]} #{Time.now.day}, #{Time.now.year}"
  end
end
