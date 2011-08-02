class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :document_file_name
      t.string :document_content_type
      t.integer :document_file_size
      t.datetime :document_updated_at
      t.integer :owner_id
      t.string :owner_type

      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
