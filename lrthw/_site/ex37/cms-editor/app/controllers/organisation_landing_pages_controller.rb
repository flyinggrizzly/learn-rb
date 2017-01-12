class OrganisationLandingPagesController < ApplicationController
  before_action :set_organisation_landing_page, only: [:show, :edit, :update, :destroy]
  before_action :set_pinned_item_list, only: [:edit, :update]
  before_action only: [:new, :edit] { status_for(@organisation_landing_page) }

  # GET /organisation_landing_pages/1
  # GET /organisation_landing_pages/1.json
  def show
  end

  # GET /organisation_landing_pages/new
  def new
    @organisation_landing_page = OrganisationLandingPage.new
    @organisation_landing_page.content_item = ContentItem.new
  end

  # GET /organisation_landing_pages/1/edit
  def edit
    create_highlight_objects
  end

  # POST /organisation_landing_pages
  # POST /organisation_landing_pages.json
  def create
    @organisation_landing_page = OrganisationLandingPage.new(organisation_landing_page_params)

    respond_to do |format|
      action_message_for('new')
      if create_organisation_landing_page
        format.html { redirect_to redirect_target(@organisation_landing_page), flash: @feedback_flash }
        format.json { render :show, status: :created, location: @organisation_landing_page }
      else
        create_highlight_objects
        format.html { render :new }
        format.json { render json: @organisation_landing_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organisation_landing_pages/1
  # PATCH/PUT /organisation_landing_pages/1.json
  def update
    respond_to do |format|
      action_message_for(@organisation_landing_page.content_item.status)
      if update_organisation_landing_page
        format.html { redirect_to redirect_target(@organisation_landing_page), flash: @feedback_flash }
        format.json { render :show, status: :ok, location: @organisation_landing_page }
      else
        create_highlight_objects
        @organisation_landing_page.content_item.status = session[:content_item_status]
        format.html { render :edit }
        format.json { render json: @organisation_landing_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organisation_landing_pages/1
  # DELETE /organisation_landing_pages/1.json
  def destroy
    @organisation_landing_page.destroy
    respond_to do |format|
      format.html { redirect_to :delete, flash: { message: 'Landing page was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  # Does the parent organisation have content items which match the given type?
  helper_method :display_content_strata?
  def display_content_strata?(content_type)
    return false if action_name == 'new'
    @organisation_landing_page.content_type?(content_type)
  end

  private

  def create_organisation_landing_page
    prepare_created_for(@organisation_landing_page)
    @organisation_landing_page.save
  end

  def update_organisation_landing_page
    prepare_update_for(@organisation_landing_page)
    @organisation_landing_page.update(organisation_landing_page_params)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_organisation_landing_page
    @organisation_landing_page = OrganisationLandingPage.find(params[:id])
  end

  # Find all items which can be pinned on the landing page
  def set_pinned_item_list
    @pinned_item_list = ContentItem.all_pinnable_by_org(@organisation_landing_page.content_item.organisation)
  end

  def create_highlight_objects
    ContentTypeListService.without_landing_pages.each do |type|
      (6 - @organisation_landing_page.send("highlighted_#{type.underscore.pluralize}").size).times do
        @organisation_landing_page.send("highlighted_#{type.underscore.pluralize}").new
      end
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def organisation_landing_page_params
    params.require(:organisation_landing_page).permit(:subtype,
                                                      :about,
                                                      :contact_name,
                                                      :contact_email,
                                                      :contact_phone,
                                                      :location,
                                                      :on_off_campus,
                                                      :building,
                                                      :room,
                                                      :address_1,
                                                      :address_2,
                                                      :town,
                                                      :postcode,
                                                      :country,
                                                      :featured_item_1,
                                                      :featured_item_2,
                                                      :featured_item_3,
                                                      :featured_item_4,
                                                      :featured_item_5,
                                                      :featured_item_6,
                                                      :content_list,
                                                      highlighted_announcements_attributes: [:id,
                                                                                             :item,
                                                                                             :item_type,
                                                                                             :item_order,
                                                                                             :_destroy],
                                                      highlighted_campaigns_attributes: [:id,
                                                                                         :item,
                                                                                         :item_type,
                                                                                         :item_order,
                                                                                         :_destroy],
                                                      highlighted_case_studies_attributes: [:id,
                                                                                            :item,
                                                                                            :item_type,
                                                                                            :item_order,
                                                                                            :_destroy],
                                                      highlighted_corporate_informations_attributes: [:id,
                                                                                                      :item,
                                                                                                      :item_type,
                                                                                                      :item_order,
                                                                                                      :_destroy],
                                                      highlighted_events_attributes: [:id,
                                                                                      :item,
                                                                                      :item_type,
                                                                                      :item_order,
                                                                                      :_destroy],
                                                      highlighted_guides_attributes: [:id,
                                                                                      :item,
                                                                                      :item_type,
                                                                                      :item_order,
                                                                                      :_destroy],
                                                      highlighted_locations_attributes: [:id,
                                                                                         :item,
                                                                                         :item_type,
                                                                                         :item_order,
                                                                                         :_destroy],
                                                      highlighted_person_profiles_attributes: [:id,
                                                                                               :item,
                                                                                               :item_type,
                                                                                               :item_order,
                                                                                               :_destroy],
                                                      highlighted_projects_attributes: [:id,
                                                                                        :item,
                                                                                        :item_type,
                                                                                        :item_order,
                                                                                        :_destroy],
                                                      highlighted_publications_attributes: [:id,
                                                                                            :item,
                                                                                            :item_type,
                                                                                            :item_order,
                                                                                            :_destroy],
                                                      highlighted_service_starts_attributes: [:id,
                                                                                              :item,
                                                                                              :item_type,
                                                                                              :item_order,
                                                                                              :_destroy],
                                                      highlighted_team_profiles_attributes: [:id,
                                                                                             :item,
                                                                                             :item_type,
                                                                                             :item_order,
                                                                                             :_destroy],
                                                      content_item_attributes: [:id,
                                                                                :as_a,
                                                                                :i_need,
                                                                                :so_that,
                                                                                :title,
                                                                                :summary,
                                                                                :status,
                                                                                :organisation_id,
                                                                                associated_org_ids: [],
                                                                                label_ids: []]
                                                     )
  end
end
