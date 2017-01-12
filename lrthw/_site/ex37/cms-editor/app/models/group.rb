class Group < Organisation
  # TODO: refactor away from STI to use polymorphism
  # because this child is also inheriting all of the relationships that Organisation has
  belongs_to :organisation, inverse_of: :groups, foreign_key: 'parent_organisation_id'
  has_and_belongs_to_many :group_users, class_name: 'User', inverse_of: :groups
  has_and_belongs_to_many :associated_group_orgs, class_name: 'Organisation', inverse_of: :associated_org_groups, join_table: 'associated_orgs_groups'

  validates :organisation, presence: true

  def name_and_type
    "#{name} - #{type}"
  end
end
