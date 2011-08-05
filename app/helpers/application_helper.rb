module ApplicationHelper
  
  #Some global variables, which are hoped to turn down the amount of database-calls
  
  $active_tab = 2
  @active_page = "no.no"
  $recent_jobs_ids
  
  def title 
    base_title = "Submarine"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
    
  end
          
  #Returns value for html class attribute according to given value
  
  #Descr: Compares given value with global variable active_tab and answers accordingly
  
  def am_i_active_tab (t)
    if t == $active_tab
      "active"
    else
      "non-active"
    end      
  end
  
  #Returns stylesheets for a page
  
  #Descr: Layouts_style.css is always applied and therefore it's always added as first item of the array
  # Second stylesheet is added according to value of active_page global variable.
  
  def get_stylesheets
    @sheets = ["layout_style.css"]
    
    if $active_page =="index.index"
      @sheets.push("./index/index_style.css")
    end
    if $active_page == "job.index"
      @sheets.push("./job/index_style.css")
    end  
    if $active_page == "job.show"
      @sheets.push("./job/show_style.css")
    end  
    if $active_page == "job.new"
      @sheets.push("./job/new_style.css")
    end
    if $active_page == "subcontractor.index"
      @sheets.push("./subcontractor/index_style.css")
    end
    if $active_page == "subcontractor.show"
      @sheets.push("./subcontractor/show_style.css")
    end
    if $active_page == "subcontractor.new"
      @sheets.push("./subcontractor/new_style.css")
    end
    if $active_page == "supplier.show"
      @sheets.push("./supplier/show_style.css")
    end
    if $active_page == "vendor.show"
      @sheets.push("./vendor/show_style.css")
    end
    if $active_page == "vendor.index"
      @sheets.push("./vendor/index_style.css")
    end
    if $active_page == "list_item.index"
      @sheets.push("./list_item/index_style.css")
    end
    if $active_page == "list_item.new"
      @sheets.push("./list_item/new_style.css")
    end
    if $active_page == "vendor.new"
      @sheets.push("./vendor/new_style.css")
    end
    if $active_page == "assignment.new"
      @sheets.push("./assignment/new_style.css")
    end
    
    return @sheets
  
  end
    
   #Returns status icon filename of given status
   
   #Descr: For each state, there is a certain icon and its file. The given value is compared
   # to find the right filename.
    
  def get_image (t)
    @answer
    if t == 1
      @answer = "overdue.png"
    end
    if t == 2
      @answer = "open.png"
    end
    if t == 3
      @answer = "waiting.png"
    end
    if t == 4
      @answer = "complete.png"
    end
    
    return @answer
  end
  
  #Returns correct status image/icon filename for a job
  
  #Descr: Gets all items of a job from database in ascending order (overdue first, open second etc)
  #Calls get_image method to get correct status icon for the item, which also is the status icon of the job
  
  def get_image_by_job (t)
      
    @items = ListItem.find_all_by_job_number(t, :order => "TRIM(LOWER(state))")
    
    if @items[0].nil?
       @answer = "complete.png"
    else
      @answer = get_image(@items[0].state) 
    end
    
    
    return @answer
  end
  
  def get_image_by_job_and_sub (t, i)
    @suppliers_data = JobPartnerPartner.find_all_by_job_number_and_partner_id(t, i)
    @supplier_ids = [];
    
    @suppliers_data.each do |j|
      @supplier_ids.push(j.p_partner_id)
    end
    
    @states = []
    
    @supplier_ids.each do |j|
      @suppliers_items = ListItem.find_all_by_job_number_and_partner_id(t, j, :order => "TRIM(LOWER(state))")
      @suppliers_items.each do |o|
        @states.push(o.state)
      end
    end
    
    @states.sort
    
    
    @answer = get_image @states[0]
    
    return @answer
  end
  
  def get_image_by_job_and_sup (t, i)
    @items = ListItem.find_all_by_job_number_and_partner_id(t, i, :order => "state")
    
    @answer = get_image @items[0].state
    
    return @answer
  end
  
  def refresh_states
    ChecklistItem.all.each do |i|
      if (Time.now.utc - i.touched_at) > 864000
        i.state = 1
      end
    end
  end
  
  def get_time
    @time  = "#{Time.now.year}-#{Time.now.mon}-#{Time.now.day} #{Time.now.hour}:#{Time.now.min}"
  end
  
  def set_states(job)
    job.state = (job.checklist_items.collect {|i| i.state}).flatten.sort!.first
    if job.state.nil?
      job.state = 4
    end
    
    job.subcontractors.each do |i|
      set_subs_state(i, job.id)
    end    
  end
  
  def set_subs_state(sub, job_id)    
    sub.state =  sub.checklist_items(job_id, 0).collect {|i| i.state}.flatten.sort!.first
    if sub.state.nil?
      sub.state = 4
    end
        
    sub.suppliers(job_id).each do |i|
      i.checklist_items(job_id, sub.id).collect {|j| j.state}.flatten.sort!.first
      if i.state.nil?
        i.state = 4
      end
    end
    
    unless sub.subcontractors(job_id).first.nil?
      sub.subcontractors(job_id).each do |i|
        set_subs_state(i, job_id)
        
        unless sub.suppliers(job_id).first.nil?
          sub.suppliers(job_id).each do |j|
            j.state = (Assignment.find_by_job_id_and_parent_id_and_partner_id_and_partner_type(job_id, sub.id, j.id, 2).checklist_items.collect {|k| k.state}.flatten.sort!.first).first
            if j.state.nil?
              j.state = 4
            end            
          end
        end        
        i.state = (i.suppliers(job_id).collect {|j| j.state }).flatten.sort!.first         
      end
    end
  end 
  
  def recents_add(job_id)
    unless RecentJobs.all.collect {|i| i.job_id}.include?(job_id)
      RecentJobs.create(:job_id => job_id)
    end
    
    if RecentJobs.all.length > 3
      RecentJobs.first.delete
    end    
  end  
end
