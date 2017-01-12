class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]
  before_action only: [:new, :edit] { status_for(@campaign) }

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
  end

  # GET /campaigns/new
  def new
    @campaign = Campaign.new
    @campaign.content_item = ContentItem.new
    1.times { @campaign.benefits.new }
    1.times { @campaign.partners.new }
  end

  # GET /campaigns/1/edit
  def edit
    1.times { @campaign.benefits.new }
    1.times { @campaign.partners.new }
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
    @campaign = Campaign.new(campaign_params)

    respond_to do |format|
      action_message_for('new')
      if create_campaign
        format.html { redirect_to redirect_target(@campaign), flash: @feedback_flash }
        format.json { render :show, status: :created, location: @campaign }
      else
        1.times { @campaign.benefits.new } if @campaign.benefits.size == 0
        1.times { @campaign.partners.new } if @campaign.partners.size == 0
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /campaigns/1
  # PATCH/PUT /campaigns/1.json
  def update
    respond_to do |format|
      action_message_for(@campaign.content_item.status)
      if update_campaign
        format.html { redirect_to redirect_target(@campaign), flash: @feedback_flash }
        format.json { render :show, status: :ok, location: @campaign }
      else
        1.times { @campaign.benefits.new } if @campaign.benefits.size == 0
        1.times { @campaign.partners.new } if @campaign.partners.size == 0
        @campaign.content_item.status = session[:content_item_status]
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaigns/1
  # DELETE /campaigns/1.json
  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to :delete, flash: { message: 'Campaign was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private

  def create_campaign
    prepare_created_for(@campaign)
    @campaign.save
  end

  def update_campaign
    prepare_update_for(@campaign)
    @campaign.update(campaign_params)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_campaign
    @campaign = Campaign.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def campaign_params
    params.require(:campaign).permit(:subtype,
                                     :status,
                                     :featured_image,
                                     :featured_image_alt,
                                     :featured_image_caption,
                                     :start,
                                     :end,
                                     :supporting_information,
                                     :contact_name,
                                     :contact_email,
                                     :contact_phone,
                                     benefits_attributes: [:id,
                                                           :description,
                                                           :call_to_action_type,
                                                           :call_to_action_label,
                                                           :call_to_action_content,
                                                           :call_to_action_reason,
                                                           :image,
                                                           :image_alt,
                                                           :image_caption,
                                                           :object_title,
                                                           :object_embed_code,
                                                           :_destroy],
                                     partners_attributes: [:id,
                                                           :name,
                                                           :logo_url,
                                                           :logo_alt,
                                                           :link_url,
                                                           :link_text,
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
