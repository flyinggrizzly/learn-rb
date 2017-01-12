# Methods for generating filenames and paths
module FilepathService
  # Determine the type of content and construct the directory from it
  # eg CaseStudy -> case-studies
  def self.generate_path(class_name, subtype)
    return 'groups' if class_name == 'OrganisationLandingPage' && subtype == 'group'
    return 'departments' if class_name == 'OrganisationLandingPage' && subtype == 'organisation'
    return 'profiles' if class_name == 'PersonProfile'
    return 'services' if class_name == 'ServiceStart'
    return 'teams' if class_name == 'TeamProfile'
    class_name.underscore.dasherize.pluralize
  end

  def self.format_filename(content_item)
    # Content_item here is something like TeamProfile, hence the strange method call
    title = content_item.content_item.title
    # Append the role_holder_name for staff person profiles
    title += '-' + content_item.role_holder_name if content_item.class.name == 'PersonProfile'

    # Strip out apostrophes
    filename = title.gsub(/['’`]/, '')
    # Normalisation from http://stackoverflow.com/a/292598 - so that we can deal with ridiculous things like ắḉútế
    ActiveSupport::Multibyte::Unicode.normalize(filename, :kd).gsub(/[^\x00-\x7F]/, '').parameterize.downcase
  end

  def self.generate_url_path(content_item)
    subtype = (content_item.has_attribute?('subtype') ? content_item.subtype : nil)
    File.join('/', generate_path(content_item.class.name, subtype), format_filename(content_item))
  end
end
