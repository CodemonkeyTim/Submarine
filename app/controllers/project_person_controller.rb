class ProjectPersonController < ApplicationController
  
  #A View Action
  def edit_page
    @pms = ProjectManager.all
    @pms.delete(@pms.first)
    
    @pes = ProjectEngineer.all
    @pes.delete(@pes.first)
  end
  
  #A Background Action
  def create
    if params[:type] == "1"
      @pp = ProjectManager.create(:name => params[:name])
    end
    if params[:type] == "2"
      @pp = ProjectEngineer.create(:name => params[:name])
    end
    render :text => @pp.id
  end
  
  #An Ajax Action
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
  
  #An Ajax Action
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