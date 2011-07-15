class SubcontractorsController < ApplicationController
  def show 
    @sub_id = params[:id]
    @job_id = params[:format]
    @job = Job.find_by_job_number(@job_id)
    @supplier_data = JobPartnerPartner.find_all_by_job_number_and_partner_id(@job_id, @sub_id)
    @supplier_ids = []
    
    @supplier_data.each do |i| 
      @supplier_ids.push(i.p_partner_id) 
    end 
    
    @suppliers  = Partner.find_all_by_id(@supplier_ids)
    @subcontractor = Partner.find(@sub_id)
  end

  def index
    @subcontractors = Partner.find_all_by_partner_type(1)
    @suppliers = Partner.find_all_by_partner_type(2)    
  end
  
  def new
    
    
  end
  
  def create
    
  end
  
  def create_address
    
  end

  def create_contact
    
  end



end
