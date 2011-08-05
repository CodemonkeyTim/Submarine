class DocumentsController < ApplicationController
  def new
    if params[:owner_type] == "job"
      @owner = Job.find(params[:owner_id])
      @owner_name = @owner.name
      @owner_type = 1
    end
    if params[:owner_type] == "asg"
      @owner = Assignment.find(params[:owner_id])
      @owner_name = Partner.find(params[:owner_id]).name
      @owner_type = 2
    end
  end
  
  def edit
  end
  
  def create
    @owner
    @owner_id = params[:owner_id]
    @owner_type = params[:owner_type]
    
    if @owner_type == "1"
      @owner = Job.find(@owner_id)
    end
    
    if @owner_type == "2"
      @owner = Assignment.find(@owner_id)
    end
    
    @doc = @owner.documents.create(:name => params[:name])
    @doc.document = params[:document]
    @doc.save
    
    @owner.logs.create(:target_type => "Document", :target_name => params[:name], :action => "added", :time => get_time, :date => get_date")  
  end
end
