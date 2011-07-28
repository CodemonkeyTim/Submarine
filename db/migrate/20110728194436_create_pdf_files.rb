class CreatePdfFiles < ActiveRecord::Migration
  def self.up
    create_table :pdf_files do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :pdf_files
  end
end
