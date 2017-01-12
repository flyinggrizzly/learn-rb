# TODO: this needs to be ripped out or changed when we implement multiple Organisations
namespace :associate_org do
  desc 'Associate User and ContentItem entries with default org'
  task load: :environment do
    # As long as there's not already an org, we create it and
    # associate Users and ContentItems to it.
    org = Organisation.create(name: 'University of Bath') if Organisation.all.blank?

    unless org.blank?
      User.find_each do |user|
        user.update(organisation: org)
      end
    end

    unless org.blank?
      ContentItem.find_each do |item|
        item.update(organisation: org)
      end
    end
  end

  desc 'Make an AssociatedOrg object for every existing Organisation that doesn\'t already have one'
  task duplicate: :environment do
    # Fetch all Organisation object, check for an equivalent AssociatedOrg
    Organisation.find_each do |org|
      begin
        ao = AssociatedOrg.find(name: org.name)
      rescue ActiveRecord::RecordNotFound
        AssociatedOrg.create(
          name: org.name,
          contact_information: org.contact_information
        )
      end
    end
  end
end
