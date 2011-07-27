module ListItemHelper
  
  def get_vendorname(vendor_id, vendor_type)    
    if vendor_type == "Subcontractor"
      @answer = Subcontractor.find(vendor_id).name
    end
    
    if vendor_type == "Supplier"
      @answer = Supplier.find(vendor_id).name      
    end    
    
    return @answer
  end
  
  def get_job_details job_number
    "#{Job.find_by_job_number(job_number).job_number} / #{Job.find_by_job_number(job_number).name}"
  end
  
end
