class VendorsController < ApplicationController
  def index
    @suppliers = Supplier.all
    @subcontractors = Subcontractor.all
    
  end

  def show
    @vendor
    
    if params[:type] == "1"
      @vendor = Subcontractor.find(params[:id])
      @jobs = @vendor.jobs.all
    end
    if params[:type] == "2"
      @vendor = Supplier.find(params[:id])
      @jobs = @vendor.subcontractors.collect {|i| i.jobs}.flatten
    end
    
    @overdue_items = @vendor.checklist_items.find_all_by_state(1)
    @open_items = @vendor.checklist_items.find_all_by_state(2)
    @waiting_items = @vendor.checklist_items.find_all_by_state(3)
    @completed_items = @vendor.checklist_items.find_all_by_state(4)
    
    
  end

end
