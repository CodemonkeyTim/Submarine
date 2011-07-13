class IndexController < ApplicationController
  def index
    @title = "Index"
    @jobs = Job.find(:all)
  end

end
