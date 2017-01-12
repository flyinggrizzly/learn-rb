class RemoveSubjectFromCaseStudy < ActiveRecord::Migration
  def up
    remove_column :case_studies, :subject
  end

  def down
    add_column :case_studies, :subject, :string
  end
end
