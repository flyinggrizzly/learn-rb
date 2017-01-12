class TeamProfilesController < ApplicationController
  before_action :set_team_profile, only: [:show, :edit, :update, :destroy]
  before_action only: [:new, :edit] { status_for(@team_profile) }

  # GET /team_profiles/1
  # GET /team_profiles/1.json
  def show
  end

  # GET /team_profiles/new
  def new
    @team_profile = TeamProfile.new
    @team_profile.content_item = ContentItem.new
    5.times { @team_profile.team_memberships.new }
    2.times { @team_profile.subsets.new }
  end

  # GET /team_profiles/1/edit
  def edit
    3.times { @team_profile.team_memberships.new }
    1.times { @team_profile.subsets.new }
  end

  # POST /team_profiles
  # POST /team_profiles.json
  def create
    @team_profile = TeamProfile.new(team_profile_params)

    respond_to do |format|
      action_message_for('new')
      if create_team_profile
        format.html { redirect_to redirect_target(@team_profile), flash: @feedback_flash }
        format.json { render :show, status: :created, location: @team_profile }
      else
        5.times { @team_profile.team_memberships.new }
        1.times { @team_profile.subsets.new }
        format.html { render :new }
        format.json { render json: @team_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /team_profiles/1
  # PATCH/PUT /team_profiles/1.json
  def update
    respond_to do |format|
      action_message_for(@team_profile.content_item.status)
      if update_team_profile
        format.html { redirect_to redirect_target(@team_profile), flash: @feedback_flash }
        format.json { render :show, status: :ok, location: @team_profile }
      else
        3.times { @team_profile.team_memberships.new }
        1.times { @team_profile.subsets.new }
        @team_profile.content_item.status = session[:content_item_status]
        format.html { render :edit }
        format.json { render json: @team_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /team_profiles/1
  # DELETE /team_profiles/1.json
  def destroy
    @team_profile.destroy
    respond_to do |format|
      format.html { redirect_to :delete, flash: { message: 'Team profile was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private

  def create_team_profile
    prepare_created_for(@team_profile)
    @team_profile.save
  end

  def update_team_profile
    prepare_update_for(@team_profile)
    @team_profile.update(team_profile_params)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_team_profile
    @team_profile = TeamProfile.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def team_profile_params
    params.require(:team_profile).permit(:subtype,
                                         :duties,
                                         :contact_name,
                                         :contact_email,
                                         :contact_phone,
                                         :membership_type,
                                         team_memberships_attributes: [:id,
                                                                       :person_profile_id,
                                                                       :team_profile_id,
                                                                       :member_order,
                                                                       :_destroy],
                                         subsets_attributes: [:id,
                                                              :title,
                                                              :membership,
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
