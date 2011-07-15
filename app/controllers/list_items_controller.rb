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
    @open_items = ListItem.find_all_by_state(1)
    @waiting_items = ListItem.find_all_by_state(2)
    @closed_items = ListItem.find_all_by_state(3)
  end

end
