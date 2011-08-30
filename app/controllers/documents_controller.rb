class DocumentsController < ApplicationController
  def new
    if params[:owner_type] == "job"
      @owner = Job.find(params[:id])
      @owner_name = @owner.name
      @owner_type = 1
    end
    if params[:owner_type] == "asg"
      @owner = Assignment.find(params[:owner_id])
      @owner_name = Partner.find(@owner.partner_id).name
      @owner_type = 2
    end
  end
  
  def edit
  end
  
  def create
    @owner
    @owner_id = params[:owner_id]
    @owner_type = params[:owner_type]
    
    @page_to_return_to
    
    if @owner_type == "1"
      @owner = Job.find(@owner_id)
      @page_to_return_url = "/jobs/#{@owner.id}"
    end
    
    if @owner_type == "2"
      @owner = Assignment.find(@owner_id)
      if @owner.partner_type == 1
        @page_to_return_to = "/subcontractors/#{@owner.partner_id}?job_id=#{@owner.job_id}&parent_id=#{@owner.parent_id}"
      else
        @page_to_return_to = "/suppliers/#{@owner.partner_id}?job_id=#{@owner.job_id}&parent_id=#{@owner.parent_id}"
      end
    end
    
    @doc = @owner.documents.create(:name => params[:name])
    @doc.document = params[:document]
    @doc.save
    
    
    @owner_id = RecentJobs.last.job_id
    @owner_type2 = "jobs"
    
    @owner.logs.create(:target_type => "Document", :target_name => params[:name], :action => "added", :time => get_time, :date => get_date)
    
  end
  
  def delete
    @doc = Document.find(params[:id])
    @doc.delete
  end
end
