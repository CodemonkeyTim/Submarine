class SubcontractorsController < ApplicationController
  def show 
    @sub_id = params[:id]
    @job_number = params[:format]
    
    @job = Job.find_by_job_number(@job_number)
    
    @partnerRel_data = JobPartnerPartner.find_all_by_job_number_and_partner_id(@job_number, @sub_id)
    @partner_ids = []
    @partnerRel_data.each do |i| 
      @partner_ids.push(i.p_partner_id)
    end
    @partner_data = Partner.find(@partner_ids)
        
    @supplier_ids = []
    @partner_data.each do |i| 
      if i.partner_type == 2 
        @supplier_ids.push(i.id)
      end
    end 
    
    @subcontractor_ids = []
    @partner_data.each do |i| 
      if i.partner_type == 1 
        @subcontractor_ids.push(i.id)
      end
    end
    
    @suppliers  = Partner.find_all_by_id(@supplier_ids)
    @subcontractors = Partner.find_all_by_id(@subcontractor_ids)
    
    @all_subcontractors = Partner.find_all_by_partner_type(1)
    @all_suppliers = Partner.find_all_by_partner_type(2)
    
    @subcontractor = Partner.find_by_id(@sub_id)
        
    @contact_person = ContactPerson.find(PartnerContactPerson.find_by_partner_id(@sub_id).contact_id)
    
    @items = ListItem.find_all_by_job_number_and_partner_id(@job.job_number, @sub_id)
    
  end

  def index
    @partners = Partner.find(:all)
  
  end
  
  def new
    
    
  end
  
  def create
    
  end
  
  def create_address
    
  end

  def create_contact
    
  end
  
  def sort
    
  end



end
