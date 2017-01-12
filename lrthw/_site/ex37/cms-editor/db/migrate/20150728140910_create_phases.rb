class CreatePhases < ActiveRecord::Migration
  def change
    create_table :phases do |t|
      t.string :title
      t.text :summary
      t.date :start
      t.date :end
      t.string :budget
      t.belongs_to :project, index: true

      t.timestamps null: false
    end
    add_foreign_key :phases, :projects
  end
end
