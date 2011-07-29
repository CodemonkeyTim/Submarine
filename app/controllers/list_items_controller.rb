class ListItemsController < ApplicationController
  def new          
    @job = Job.find_by_job_number(params[:job_number])
    
    @type = params[:type]
    
    if @type == "Subcontractor"
      @vendor = Subcontractor.find(params[:id])
      @sups_subs_id = 0
    end
    if @type == "Supplier"
      @vendor = Supplier.find(params[:id])
      @sups_subs_id = params[:sub_id]
    end
    
  end

  def create
    if params[:type] == "Subcontractor"
      Job.find_by_job_number(params[:job_number]).subcontractors.find(params[:sub_id]).checklist_items.new(:item_data => params[:item_data], :state => 3, :touched_at => (Time.now.utc+9000000000), :job_number => params[:job_number]).save
      
      Job.find_by_job_number(params[:job_number]).logs.push(Log.new(:log_data => "#{params[:item_data]} added at #{Time.now}", :log_level => 2))
      
      #File.open("/home/codemonkey/rails/Submarine/log/history_logs/#{Subcontractor.find(params[:sub_id]).name}-in-#{@job.job_number}.log", 'a') do |i|
      #  i.write("#{params[:item_data]} added at #{Time.now}")
      #end
    end
    if params[:type] == "Supplier"
      Job.find_by_job_number(params[:job_number]).subcontractors.find(params[:sups_subs_id]).suppliers.find(params[:sub_id]).checklist_items.new(:item_data => params[:item_data], :state => 3, :touched_at => (Time.now.utc+9000000000), :job_number => params[:job_number]).save
      
      Job.find_by_job_number(params[:job_number]).logs.push(Log.new(:log_data => "#{params[:item_data]} added at #{Time.now}", :log_level => 3))
      
      #File.open("/home/codemonkey/rails/Submarine/log/history_logs/#{Supplier.find(params[:sub_id]).name}-in-#{@job.job_number}-for-#{Subcontractor.find(params[:sups_subs_id])}.log", 'a') do |i|
      #  i.write("#{parama[:item_data]} added at #{Time.now}")
      #end
    end    
  end

  def show
  end

  def index
    
    #All items categorized by state
    @overdue_items = []
    @open_items = [] 
    @waiting_items = [] 
    @completed_items = []   
    
    @jobs = Job.all
    
    @jobs.each do |i|
      @items = (i.subcontractors.collect {|j| j.checklist_items} + i.subcontractors.collect {|j| j.suppliers.collect {|k| k.checklist_items}}).flatten
      @items.each do |j|
        j.job_number = i.job_number
      end
      
      @items.each do |j|
        if j.state == 1
          @overdue_items.push(j)
        end
        if j.state == 2
          @open_items.push(j)
        end
        if j.state == 3
          @waiting_items.push(j)
        end
        if j.state == 4
          @completed_items.push(j)
        end
      end
      
    end    
    
  end

end
