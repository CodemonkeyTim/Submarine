class ApplicationController < ActionController::Base
  protect_from_forgery 
  
  def get_time
    @abbs = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
    @time  = "#{@abbs[Time.now.mon]} #{Time.now.day}, #{Time.now.year} #{Time.now.hour}:#{Time.now.min}"
  end
end
