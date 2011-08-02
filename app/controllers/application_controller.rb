class ApplicationController < ActionController::Base
  protect_from_forgery 
  
  def get_time
    @time  = "#{Time.now.year}-#{Time.now.mon}-#{Time.now.day} #{Time.now.hour}:#{Time.now.min}"
  end
end
