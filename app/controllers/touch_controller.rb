class TouchController < ApplicationController
  def touch 
    @t = params[:id]
    @item = ListItem.find(@t)
    @item.touched_at = Time.now
    @item.save
  end
end
