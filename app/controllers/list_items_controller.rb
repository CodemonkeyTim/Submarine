class ListItemsController < ApplicationController
  def new
    @vendor_id = params[:id]
    
    @job = Job.find_by_job_number(params[:job_number])
    
    @type = params[:type]
  end

  def create
    if params[:type] == "Subcontractor"
      Job.find_by_job_number(params[:job_number]).subcontractors.find(params[:sub_id]).checklist_items.new(:item_data => params[:item_data], :state => 3).save
    else
      
    end
    
  end

  def show
  end

  def index
    
    #All items categorized by state
    @overdue_items = []
    @open_items = [] 
    @waiting_items = [] 
    @completed_items = []   
    
    @jobs = Job.all
    
    @jobs.each do |i|
      @items = (i.subcontractors.collect {|j| j.checklist_items} + i.subcontractors.collect {|j| j.suppliers.collect {|k| k.checklist_items}}).flatten
      @items.each do |j|
        j.job_number = i.job_number
      end
      
      @items.each do |j|
        if j.state == 1
          @overdue_items.push(j)
        end
        if j.state == 2
          @open_items.push(j)
        end
        if j.state == 3
          @waiting_items.push(j)
        end
        if j.state == 4
          @completed_items.push(j)
        end
      end
      
    end    
    
  end

end
