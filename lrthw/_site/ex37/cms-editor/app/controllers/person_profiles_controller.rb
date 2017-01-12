class PersonProfilesController < ApplicationController
  before_action :set_person_profile, only: [:show, :edit, :update, :destroy]
  before_action :set_enums, only: [:new, :edit, :create, :update]
  before_action only: [:new, :edit] { status_for(@person_profile) }

  # GET /person_profiles/1
  # GET /person_profiles/1.json
  def show
  end

  # GET /person_profiles/new
  def new
    @person_profile = PersonProfile.new
    @person_profile.content_item = ContentItem.new
    3.times { @person_profile.urls.new }
  end

  # GET /person_profiles/1/edit
  def edit
    3.times { @person_profile.urls.new }
  end

  # POST /person_profiles
  # POST /person_profiles.json
  def create
    @person_profile = PersonProfile.new(person_profile_params)

    respond_to do |format|
      action_message_for('new')
      if create_person_profile
        format.html { redirect_to redirect_target(@person_profile), flash: @feedback_flash }
        format.json { render :show, status: :created, location: @person_profile }
      else
        format.html { render :new }
        format.json { render json: @person_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /person_profiles/1
  # PATCH/PUT /person_profiles/1.json
  def update
    respond_to do |format|
      action_message_for(@person_profile.content_item.status)
      if update_person_profile
        format.html { redirect_to redirect_target(@person_profile), flash: @feedback_flash }
        format.json { render :show, status: :ok, location: @person_profile }
      else
        @person_profile.content_item.status = session[:content_item_status]
        format.html { render :edit }
        format.json { render json: @person_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /person_profiles/1
  # DELETE /person_profiles/1.json
  def destroy
    @person_profile.destroy
    respond_to do |format|
      format.html { redirect_to :delete, flash: { message: 'Person profile was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private

  def create_person_profile
    prepare_created_for(@person_profile)
    @person_profile.save
  end

  def update_person_profile
    prepare_update_for(@person_profile)
    @person_profile.update(person_profile_params)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_person_profile
    @person_profile = PersonProfile.find(params[:id])
  end

  def set_enums
    @availabilities = PersonProfile.supervisor_availabilities
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def person_profile_params
    params.require(:person_profile).permit(:role_holder_name,
                                           :role_holder_title,
                                           :honours_post_nominal_letters,
                                           :role_holder_photo_url,
                                           :role_holder_photo_alt_text,
                                           :role_holder_photo_caption,
                                           :role_related_posts_held,
                                           :achievements_in_role,
                                           :career_achievements,
                                           :education,
                                           :all_publications_url,
                                           :supervisor_availability,
                                           :courses_taught_undergrad,
                                           :courses_taught_postgrad,
                                           :research_interests,
                                           :current_research_projects,
                                           :contact_name,
                                           :contact_email,
                                           :contact_phone,
                                           :person_finder_link,
                                           :subtype,
                                           urls_attributes: [:id, :url, :_destroy],
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
