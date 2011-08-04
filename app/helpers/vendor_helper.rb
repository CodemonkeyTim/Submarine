module VendorHelper
  
  $parent_ids = []
  
  def get_roles(job_id, partner_id)
    @assignments = Assignment.find_all_by_job_id_and_partner_id(job_id, partner_id)
    
    @roles = []
    
    @assignments.each do |i|
      $parent_ids.push(i.parent_id)
            
      if i.parent_id == 0
        @parent_name = "TU"
      else
        @parent_name = Partner.find(i.parent_id).name
      end
      
      @job = Job.find(job_id)
      
      if i.partner_type == 1
        @role = "Subcontractor"
      else
        @role = "Supplier"
      end
      
      @roles.push("#{@role} for #{@parent_name}")
      
    end
    
    return @roles
        
  end
  
  
  
end
