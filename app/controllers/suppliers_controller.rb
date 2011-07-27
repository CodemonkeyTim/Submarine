class SuppliersController < ApplicationController
  def show
    @supplier = Supplier.find(params[:id])
    @job = Job.find_by_job_number(params[:job_number])
    @subcontractor  = @supplier.subcontractors.find(params[:sub_id])
    
    @overdue_items = @supplier.checklist_items.find_all_by_state(1)
    @open_items = @supplier.checklist_items.find_all_by_state(2)
    @waiting_items = @supplier.checklist_items.find_all_by_state(3)
    @completed_items = @supplier.checklist_items.find_all_by_state(4)
    
    @subcontractor = 
    
    @contact_person = ContactPerson.new
    @contact_person.name = "Karl Johanson"
    @contact_person.phone_number = "360-409-3095"
    @contact_person.email = "karl@johansonarchitecture.com"
    
  end

  def index
  end

end
