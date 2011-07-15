class ListItemsController < ApplicationController
  def new
  end

  def create
    
  end

  def show
  end

  def index
    @open_items = ListItem.find_all_by_state(1)
    @waiting_items = ListItem.find_all_by_state(2)
    @closed_items = ListItem.find_all_by_state(3)
  end

end
