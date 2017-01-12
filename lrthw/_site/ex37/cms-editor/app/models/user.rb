# A representation of a user using the CMS Editor system
class User < ActiveRecord::Base
  alias_attribute :admin?, :admin
  alias_attribute :editor?, :editor
  alias_attribute :author?, :author
  alias_attribute :contributor?, :contributor

  belongs_to :organisation, inverse_of: :org_users
  has_and_belongs_to_many :groups, inverse_of: :group_users
  has_and_belongs_to_many :associated_orgs, class_name: 'Organisation', inverse_of: :associated_org_users, join_table: 'associated_orgs_users'
  before_validation :assign_initial_org

  validates :username, :organisation, presence: true
  validates :username, uniqueness: { case_sensitive: false }

  default_scope { order('display_name ASC') }

  def admin!
    self.admin = true
    self.editor = true
    self.author = true
    self.contributor = true
  end

  def editor!
    self.admin = false
    self.editor = true
    self.author = true
    self.contributor = true
  end

  def author!
    self.admin = false
    self.editor = false
    self.author = true
    self.contributor = true
  end

  def contributor!
    self.admin = false
    self.editor = false
    self.author = false
    self.contributor = true
  end

  def no_permissions!
    self.admin = false
    self.editor = false
    self.author = false
    self.contributor = false
  end

  private

  def assign_initial_org
    return unless organisation.blank?
    org = Organisation.find_by_name('University of Bath')
    self.organisation = org
  end

  class << self
    def find_or_create_user(username)
      uri = URI.parse('http://www.bath.ac.uk/personfinder/dataquery/api.php?search=true&type=json&terms=' + username)
      http = Net::HTTP.new(uri.host, uri.port)

      User.find_or_create_by(username: username) do |u|
        response = http.request(Net::HTTP::Get.new(uri.request_uri))
        if response.code == '200'
          person_finder_data = JSON.parse(response.body)
          u.display_name = person_finder_data['people'][0]['displayname']
          u.first_name = person_finder_data['people'][0]['firstname']
          u.last_name = person_finder_data['people'][0]['lastname']
          u.person_id = person_finder_data['people'][0]['personid'].to_i
        end
      end
    end
  end
end
