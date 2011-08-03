class VendorsController < ApplicationController
  def index
    @vendors  = Partner.all
    
  end

  def show
    @vendor = Partner.find(params[:id])
    @assignments = Assignment.find_all_by_partner_id(params[:id])
    
    @jobs = Job.find_all_by_id(@assignments.collect {|i| i.job_id}.flatten)
    
  end
  
  def new
    @partner = Partner.create(:name => params[:partner_name])    
  end
  
  def create
    
    
  end



end
