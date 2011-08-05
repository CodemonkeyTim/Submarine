class ApplicationController < ActionController::Base
  protect_from_forgery 
  
  def get_time
    @abbs = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
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
    
    @time  = "#{@abbs[Time.now.mon-1]} #{Time.now.day}, #{Time.now.year} #{@hour}:#{@minute} #{@amorpm}"
  end
  
end
