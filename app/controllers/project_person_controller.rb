class ProjectPersonController < ApplicationController
  def edit_page
    @pms = ProjectManager.all
    @pes = ProjectEngineer.all
  end

  def create
    if params[:type] == "1"
      @pp = ProjectManager.create(:name => params[:name])
    end
    if params[:type] == "2"
      @pp = ProjectEngineer.create(:name => params[:name])
    end
    render :text => @pp.id
  end
  
  def delete
    if params[:type] == "1"
      @pp = ProjectManager.find(params[:id])
      @pp.delete
    end
    if params[:type] == "2"
      @pp = ProjectEngineer.find(params[:id])
      @pp.delete
    end
    render :nothing => true
    
  end
  
  def update
    if params[:type] == "1"
      @pp = ProjectManager.find(params[:id])
      @pp.name = params[:name]
      @pp.save
    end
    if params[:type] == "2"
      @pp = ProjectEngineer.find(params[:id])
      @pp.name = params[:name]
      @pp.save
    end
    render :nothing => true
  end
  
end
