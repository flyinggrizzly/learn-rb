class ContentItemsController < ApplicationController
  # GET /content_item
  # GET /content_item.json
  def index
    # Set the organisation for the filter
    @organisation = Organisation.find(params[:organisation][:id]) unless params[:organisation].blank? ||
                                                                         params[:organisation][:id].blank?

    @search_query = params[:term] unless params[:term].blank?

    if current_user.admin?
      if @search_query
        search_items_for_admin(@search_query)
      else
        show_all_items
      end
    elsif @search_query
      search_items(@search_query)
    else
      show_only_users_orgs_items
    end
  end

  private

  def search_items(term)
    @content_items = ContentItem.search_title_by(term)

    # Filter out only those that belong to user's orgs
    @content_items = @content_items.select do |content_item|
      current_user_orgs.include?(content_item.organisation)
    end
  end

  def search_items_for_admin(term)
    @content_items = ContentItem.search_title_by(term)
  end

  def show_all_items
    @content_items = if @organisation.blank?
                       ContentItem.all
                     else
                       ContentItem.filter_by_org(@organisation)
                     end
    @content_items = @content_items.includes(:core_data).order(updated_at: :desc).page(params[:page])
  end

  def show_only_users_orgs_items
    @content_items = if @organisation.present? && @organisation.in?(current_user_orgs)
                       # If filter organisation is set just get those items
                       ContentItem.filter_by_org(@organisation)
                     else
                       # Get all the items owned by and associated with the user's orgs
                       items = []
                       # Get all the content items
                       current_user_orgs.each do |org|
                         items |= org.content_items unless org.content_items.blank?
                         items |= org.associated_org_content_items unless org.associated_org_content_items.blank?
                       end
                       ContentItem.where(id: items.map(&:id))
                     end
    # Fetch the content items with core_data to reduce the SQL queries in the view
    @content_items = @content_items.includes(:core_data).order(updated_at: :desc).page(params[:page])
  end
end
