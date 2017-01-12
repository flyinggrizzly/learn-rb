class MigrateBodyContentDataToSection < ActiveRecord::Migration
  # Migration model for Section - see http://jacopretorius.net/2014/07/patterns-for-data-migrations-in-rails.html
  class Section < ActiveRecord::Base; end
  # Migration model for Guide
  class Guide < ActiveRecord::Base
    has_many :sections, proc { order('created_at ASC') }
  end

  def up
    created_updated = Time.now.to_s(:db)

    Guide.find_each do |guide|
      body_content = guide.body_content
      next if body_content.nil?

      # If there aren't any associated Sections for a Guide create one
      # with migrated body content
      if guide.sections.blank?
        execute insert_sql(guide.id, created_updated)
      end
    end

    Section.reset_column_information
    Guide.reset_column_information
  end

  def down
    Section.reset_column_information
    Guide.reset_column_information
  end

  private

  def insert_sql(guide_id, created_updated)
    <<INSERT_SQL
INSERT INTO sections (id, body_content, guide_id, created_at, updated_at)
VALUES (SECTIONS_SEQ.NEXTVAL, (SELECT body_content FROM guides WHERE ID = '#{guide_id}'), '#{guide_id}', '#{created_updated}', '#{created_updated}')
INSERT_SQL
  end
end
