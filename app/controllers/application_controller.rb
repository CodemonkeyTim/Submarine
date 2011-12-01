class ApplicationController < ActionController::Base
  protect_from_forgery   
  
  #Global helper methods and vars
  
  #Array of statecodes
  $states = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "DC", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
  
  
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
  
  #Returns current date as string in format (ie "Jan 13, 2011")
  def get_date
    @abbs = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
    @date = "#{@abbs[Time.now.mon-1]} #{Time.now.day}, #{Time.now.year}"
  end
end
