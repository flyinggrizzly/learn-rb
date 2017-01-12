class AnnouncementsController < ApplicationController
  before_action :set_announcement, only: [:show, :edit, :update, :destroy]
  before_action only: [:new, :edit] { status_for(@announcement) }

  # GET /announcements/1
  # GET /announcements/1.json
  def show
  end

  # GET /announcements/new
  def new
    @announcement = Announcement.new
    @announcement.content_item = ContentItem.new
  end

  # GET /announcements/1/edit
  def edit
  end

  # POST /announcements
  # POST /announcements.json
  def create
    @announcement = Announcement.new(announcement_params)

    respond_to do |format|
      action_message_for('new')
      if create_announcement
        format.html { redirect_to redirect_target(@announcement), flash: @feedback_flash }
        format.json { render :show, status: :created, location: @announcement }
      else
        format.html { render :new }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /announcements/1
  # PATCH/PUT /announcements/1.json
  def update
    respond_to do |format|
      action_message_for(@announcement.content_item.status)
      if update_announcement
        format.html { redirect_to redirect_target(@announcement), flash: @feedback_flash }
        format.json { render :show, status: :ok, location: @announcement }
      else
        @announcement.content_item.status = session[:content_item_status]
        format.html { render :edit }
        format.json { render json: @announcement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /announcements/1
  # DELETE /announcements/1.json
  def destroy
    @announcement.destroy
    respond_to do |format|
      format.html { redirect_to :delete, flash: { message:  'Announcement was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private

  def create_announcement
    prepare_created_for(@announcement)
    @announcement.save
  end

  def update_announcement
    prepare_update_for(@announcement)
    @announcement.update(announcement_params)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_announcement
    @announcement = Announcement.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def announcement_params
    params.require(:announcement).permit(:subtype,
                                         :body_content,
                                         :featured_image,
                                         :featured_image_alt,
                                         :featured_image_caption,
                                         :object_title,
                                         :object_embed_code,
                                         :contact_name,
                                         :contact_email,
                                         :contact_phone,
                                         :call_to_action_type,
                                         :call_to_action_label,
                                         :call_to_action_content,
                                         :call_to_action_reason,
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
