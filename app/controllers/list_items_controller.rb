class ListItemsController < ApplicationController
  def new
  end

  def create
    @data = []
    
    @data.push(params[:item_data])
    @data.push(params[:partner_id])
    @data.push(params[:state])
    @data.push(params[:job_number])
    
    @list_item = ListItem.new({:item_data => @data[0], :partner_id => @data[1], :state => @data[2], :job_number => @data[3]})    
    
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
