class DocumentsController < ApplicationController
  def new
    @cli = ChecklistItem.find(params[:cli_id])
    
  end
  
  def edits
  end
  
  def create
    @cli = ChecklistItem.find(params[:cli_id])
    @cli.document = params[:document]
    @cli.save
  end
end
