class RenameTopicsToLabels < ActiveRecord::Migration
   def change
     rename_table :topics, :labels
   end
end
