class Organisation < ActiveRecord::Base
  include ActiveModel::Serialization

  has_many :org_users, class_name: 'User', inverse_of: :organisation
  has_many :groups, inverse_of: :organisation, foreign_key: 'parent_organisation_id'
  has_many :content_items, inverse_of: :organisation
  has_and_belongs_to_many :associated_org_content_items, class_name: 'ContentItem', inverse_of: :associated_orgs, join_table: 'associated_orgs_content_items'
  has_and_belongs_to_many :associated_org_users, class_name: 'User', inverse_of: :associated_orgs, join_table: 'associated_orgs_users'
  has_and_belongs_to_many :associated_org_groups, class_name: 'Group', inverse_of: :associated_group_orgs, join_table: 'associated_orgs_groups'

  validates :name, presence: true
  validates_uniqueness_of :name, case_sensitive: false

  def name_and_type
    return name if name == 'University of Bath'
    "#{name} - Department"
  end
end
