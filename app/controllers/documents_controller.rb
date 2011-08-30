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
    
    @return_page_url = ""
    
    if @owner_type == "1"
      @owner = Job.find(@owner_id)
      @return_page_url = "/jobs/#{@owner_id}"
    end
    
    if @owner_type == "2"
      @owner = Assignment.find(@owner_id)
      if @owner.partner_type == 1
        @return_page_url = "/subcontractors/#{@owner.partner_id}?job_id=#{@owner.job_id}&parent_id=#{@owner.parent_id}"
      else
        @return_page_url = "/suppliers/#{@owner.partner_id}?job_id=#{@owner.job_id}&parent_id=#{@owner.parent_id}"
      end
    end
    
    @doc = Document.new(:name => params[:name])
    @doc.document = params[:document]
    @doc.save
    @owner.documents.push(@doc)
    @owner.save    

    @owner.logs.create(:target_type => "Document", :target_name => params[:name], :action => "added", :time => get_time, :date => get_date)
  end
end
