class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Set secure headers
  ensure_security_headers

  # Use Single Sign-On
  before_action :store_return_to
  before_action CASClient::Frameworks::Rails::Filter
  before_action :check_authentication
  before_action :check_authorization, only: [:create, :update]
  before_action :check_admin_authorization, only: [:destroy]

  # Used in all controllers
  before_action :set_statuses, only: [:new, :edit, :create, :update]
  before_action :process_url_fields, only: [:create, :update]

  # Allow MiniProfiler to run in environments other than 'development'
  before_action :authorize_mini_profiler

  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end

  # Helper_method makes method available in view
  helper_method :current_user
  def current_user
    # @user should only need requesting once per page load
    @user ||= User.find_by(username: session[:cas_user])
    @user
  end

  helper_method :current_user_orgs

  # Get all of the logged in user's orgs, associated orgs and groups,
  # plus all child orgs and groups of orgs user belongs to
  def current_user_orgs
    return Organisation.order(name: :asc) if current_user.admin?
    orgs_list = [current_user.organisation] | current_user.associated_orgs | current_user.groups |
                current_user.organisation.groups
    current_user.associated_orgs.each do |ao|
      orgs_list |= ao.groups
    end
    orgs_list = orgs_list.sort_by(&:name)
    orgs_list
  end

  protected

  def store_return_to
    session[:return_to] = request.url
  end

  def check_authentication
    return if session[:user_authenticated] == true
    if session[:user_authenticated] == false
      redirect_to controller: :error, action: :no_permissions
    else
      check_user_details_and_permissions
    end
  end

  def check_user_details_and_permissions
    connect_to_ldap
    find_or_create_user
    find_user_groups
    assign_user_role
    send_to_page
  rescue
    session[:error_message] = $ERROR_INFO
    redirect_to controller: :error
  end

  def connect_to_ldap
    # Connect to LDAP to get user and group information
    @ldap = Net::LDAP.new
    @ldap.host = 'ldap.bath.ac.uk'
    @ldap.port = 389
    @ldap.bind
  end

  def find_or_create_user
    # This will only be used for initial sign in
    @user = User.find_or_create_user(session[:cas_user])
  end

  def find_user_groups
    # Get the groups that the user is in
    @users_groups = []
    @ldap.search(base: 'ou=groups,o=bath.ac.uk', filter: Net::LDAP::Filter.construct("(member=uid=#{current_user.username}*)")) do |entry|
      @users_groups.push(entry.cn.first)
    end
  end

  def assign_user_role
    # For admins, adding set-role=role when logging in drops permissions to that level
    if @users_groups.include?('cms-admins') && params[:'set-role'].blank?
      @user.admin!

    elsif @users_groups.include?('cms-editors') && params[:'set-role'].blank? ||
          (@users_groups.include?('cms-admins') && params[:'set-role'] == 'editor')
      @user.editor!

    elsif @users_groups.include?('cms-authors') && params[:'set-role'].blank? ||
          (@users_groups.include?('cms-admins') && params[:'set-role'] == 'author')
      @user.author!

    elsif @users_groups.include?('cms-contributors') && params[:'set-role'].blank? ||
          (@users_groups.include?('cms-admins') && params[:'set-role'] == 'contributor')
      @user.contributor!

    else
      @user.no_permissions!
    end

    @user.save
  end

  def send_to_page
    # If the user is at least a contributor send to the app, otherwise error page
    if @user.contributor?
      session[:user_authenticated] = true
      redirect_to(session[:return_to] || { controller: :events })
      session[:return_to] = nil
    else
      session[:user_authenticated] = false
      redirect_to controller: :error, action: :no_permissions
    end
  end

  def check_authorization
    # Admins can do anything
    return if current_user.admin?

    # No content id if item is newly created
    old_content_item = ContentItem.find_by(id: content_item_id_param)
    # If item was in review and not an editor, no permission
    if old_content_item.present? && old_content_item.status == 'in_review' && !current_user.editor?
      redirect_to controller: :error, action: :no_permissions
    end

    # Authorized unless attempting to publish and not an author (so no permission)
    return unless ContentItem.status_message_map[status_param] == 'published' && !current_user.author?
    redirect_to controller: :error, action: :no_permissions
  end

  def check_admin_authorization
    # Admins can do anything
    return if current_user.admin?
    redirect_to controller: :error, action: :no_permissions
  end

  def redirect_target(content_item)
    case status_param
    when I18n.t('shared.status_buttons.save'), I18n.t('shared.status_buttons.published_save')
      url_for([:edit, content_item])
    else
      root_url
    end
  end

  # Make the statuses ready for use in the view
  def set_statuses
    @statuses = ContentItem.statuses
  end

  # MiniProfiler requires explicit authorisation in order to run in environments other than 'development'
  def authorize_mini_profiler
    Rack::MiniProfiler.authorize_request if current_user && current_user.admin?
  end

  # Put the current content item's status in the session for when the discard button is used
  # We also use this value when we fail to save on validation error but need to show the user the unchanged status
  def status_for(content_item)
    session[:content_item_status] = action_name == 'new' ? 'new' : content_item.content_item.status
  end

  def prepare_update_for(content_item)
    # Always update the content item updated_at field to trigger a new Papertrail version
    # Round to nearest second because the database doesn't store milliseconds
    content_item.updated_at = DateTime.now.to_time.round.in_time_zone
    content_item.content_item.updated_at = content_item.updated_at
    content_item.content_item.updated_by = current_user.username
    content_item.content_item.status = ContentItem.status_message_map[status_param]
  end

  def prepare_created_for(content_item)
    content_item.content_item.created_by = current_user.username
    content_item.content_item.organisation = current_user.organisation
    content_item.content_item.status = ContentItem.status_message_map[status_param]
  end

  def action_message_for(old_status)
    action = ContentItem.action_map(status_param)
    @feedback_flash = { message: I18n.t("action_messages.#{old_status}_#{action}") }
  end

  def content_item_id_param
    id_param = nil
    # Get the id of the content item
    unless params[:id].blank?
      # Grab the type from the url and turn it into a constant
      type = request.fullpath.split('/')[1].camelize.singularize
      id_param = type.constantize.find(params[:id]).content_item.id
    end
    id_param
  end

  def status_param
    params.require(:commit)
  end

  # Strip off protocol and host for internal CMS links in URL fields
  # TODO: Consider refactoring into concerns on a per feature basis, eg featured images, CTAs
  def process_url_fields
    fields = params[params[:controller].singularize]
    [:all_publications_url,
     :booking_link,
     :call_to_action_content,
     :featured_image,
     :image,
     :link_url,
     :logo_url,
     :person_finder_link,
     :role_holder_photo_url,
     :urls_attributes].each do |f|
      next if fields[f].blank?
      if f == :urls_attributes
        fields[f].map(&:second).map { |u| strip_internal_url(u[:url]) }
      else
        strip_internal_url(fields[f])
      end
    end
  end

  def strip_internal_url(url)
    pattern = %r{^http://(staging-beta|training-beta|beta).bath.ac.uk}
    url.sub!(pattern, '')
  end
end
