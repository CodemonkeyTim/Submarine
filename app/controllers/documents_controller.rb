class DocumentsController < ApplicationController
  def new
    if params[:owner_type] == "job"
      @owner = Job.find(params[:id])
      @owner_type = "Job"
    end
    if params[:owner_type] == "sub"
      
    end
    if params[:owner_type] == "sup"
      
    end
  end
  
  def edit
  end
  
  def create
    @doc = Document.new
    @doc.owner_type = params[:owner_type]
    @doc.owner_id = params[:owner_id]    
    @doc.document = params[:document]
    @doc.name = params[:name]
    @doc.save
    
    if params[:owner_type] == "Job"
      @owner = Job.find(params[:owner_id])
    end
    if params[:owner_type] == "sub"
      
    end
    if params[:owner_type] == "sup"
      
    end
    
    @owner.log_markings.push(LogMarking.new(:log_data => "Document #{params[:name]} added at #{get_time}"))
    
  end
end
