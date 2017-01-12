class RelateAssociatedOrgsAndContentItems < ActiveRecord::Migration
  def change
    create_table :associated_orgs_content_items, id: false do |t|
      t.belongs_to :associated_org, index: true
      t.belongs_to :content_item, index: true
    end
  end
end
