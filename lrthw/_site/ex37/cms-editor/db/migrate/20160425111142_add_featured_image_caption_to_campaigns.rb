class AddFeaturedImageCaptionToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :featured_image_caption, :string
  end
end
