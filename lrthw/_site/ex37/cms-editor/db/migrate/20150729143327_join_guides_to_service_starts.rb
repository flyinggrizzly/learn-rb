# This was generated by running: rails g migration create_join_table guide service_start
class JoinGuidesToServiceStarts < ActiveRecord::Migration
  def change
    create_join_table :guides, :service_starts do |t|
      t.index [:guide_id, :service_start_id]
      t.index [:service_start_id, :guide_id]
    end
  end
end
