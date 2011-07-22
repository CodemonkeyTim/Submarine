class IndexController < ApplicationController
  
  $jobs_subslists = []
  $list_items_to_show = []
  
  def index
    @recent_jobs = Job.find(:all)
      
  end

end
