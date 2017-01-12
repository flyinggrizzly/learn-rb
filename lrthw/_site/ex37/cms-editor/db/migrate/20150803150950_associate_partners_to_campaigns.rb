class AssociatePartnersToCampaigns < ActiveRecord::Migration
  def change
    change_table :partners do |t|
      t.belongs_to :campaign, index: true
    end
  end
end
