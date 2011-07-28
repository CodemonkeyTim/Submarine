class PdfFile < ActiveRecord::Base
  def self.save(upload)
    name = upload['datafile'].original_filename
    directory  = "public/data/PDFs"
    
  end
  
end
