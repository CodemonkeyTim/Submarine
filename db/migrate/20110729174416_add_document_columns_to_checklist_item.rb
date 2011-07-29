class AddDocumentColumnsToChecklistItem < ActiveRecord::Migration
  def self.up
    add_column :checklist_items, :document_file_name, :string
    add_column :checklist_items, :document_content_type, :string
    add_column :checklist_items, :document_file_size, :integer
    add_column :checklist_items, :document_updated_at, :datetime
  end

  def self.down
    remove_column :checklist_items, :document_updated_at
    remove_column :checklist_items, :document_file_size
    remove_column :checklist_items, :document_content_type
    remove_column :checklist_items, :document_file_name
  end
end
