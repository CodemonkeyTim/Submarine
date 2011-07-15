class SuppliersController < ApplicationController
  def show
    
    @supplier = Partner.find(params[:id])
    @job = Job.find_by_job_number(params[:format])
    
    @open_items = ListItem.find_all_by_job_number_and_partner_id_and_state(params[:format], params[:id], 1)
    @waiting_items = ListItem.find_all_by_job_number_and_partner_id_and_state(params[:format], params[:id], 2)
    @closed_items = ListItem.find_all_by_job_number_and_partner_id_and_state(params[:format], params[:id], 3)
  end

  def index
  end

end
