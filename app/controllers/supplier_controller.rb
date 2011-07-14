class SupplierController < ApplicationController
  def show
    
    @supplier = Partner.find(params[:id])
    
    @list_items = ListItem.find_all_by_job_number_and_partner_id(params[:format], params[:id])
    
  end

  def index
  end

end
