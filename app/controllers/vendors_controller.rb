class VendorsController < ApplicationController
  def index
    @vendors  = Partner.all
    
  end

  def show
    @vendor = Partner.find(params[:id])
    
    @jobs = Job.find_all_by_id(Assignment.find_all_by_partner_id(params[:id]).collect {|i| i.job_id}.flatten)    
  end

end
