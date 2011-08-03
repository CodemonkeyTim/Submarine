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
    
    @time  = "#{@abbs[Time.now.mon]} #{Time.now.day}, #{Time.now.year} #{@hour}:#{Time.now.min} #{@amorpm}"
  end
end
