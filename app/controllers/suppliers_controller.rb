class SuppliersController < ApplicationController
  def show
    @supplier = Partner.find(params[:id])
    @job = Job.find_by_job_number(params[:format])
        
    @overdue_items = ListItem.find_all_by_job_number_and_partner_id_and_state(params[:format], params[:id], 1)
    @open_items = ListItem.find_all_by_job_number_and_partner_id_and_state(params[:format], params[:id], 2)
    @waiting_items = ListItem.find_all_by_job_number_and_partner_id_and_state(params[:format], params[:id], 3)
    @completed_items = ListItem.find_all_by_job_number_and_partner_id_and_state(params[:format], params[:id], 4)
    
    @contact_person = ContactPerson.find(PartnerContactPerson.find_by_partner_id(@supplier.id).contact_id)
    
    @rel = JobPartnerPartner.find_by_job_number_and_p_partner_id(@job.job_number, @supplier.id)
    @subcontractor = Partner.find(@rel.partner_id)
    
  end

  def index
  end

end
