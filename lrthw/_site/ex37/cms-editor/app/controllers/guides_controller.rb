class GuidesController < ApplicationController
  before_action :set_guide, only: [:show, :edit, :update, :destroy]
  before_action only: [:new, :edit] { status_for(@guide) }

  # GET /guides/1
  # GET /guides/1.json
  def show
  end

  # GET /guides/new
  def new
    @guide = Guide.new
    @guide.content_item = ContentItem.new
    2.times { @guide.sections.new }
  end

  # GET /guides/1/edit
  def edit
    1.times { @guide.sections.new }
  end

  # POST /guides
  # POST /guides.json
  def create
    @guide = Guide.new(guide_params)

    respond_to do |format|
      action_message_for('new')
      if create_guide
        format.html { redirect_to redirect_target(@guide), flash: @feedback_flash }
        format.json { render :show, status: :created, location: @guide }
      else
        1.times { @guide.sections.new }
        1.times { @guide.sections.new } if @guide.subtype == 'detailed_guide' && @guide.sections.size < 2
        format.html { render :new }
        format.json { render json: @guide.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /guides/1
  # PATCH/PUT /guides/1.json
  def update
    respond_to do |format|
      action_message_for(@guide.content_item.status)
      if update_guide
        format.html { redirect_to redirect_target(@guide), flash: @feedback_flash }
        format.json { render :show, status: :ok, location: @guide }
      else
        1.times { @guide.sections.new } if @guide.subtype == 'detailed_guide'
        @guide.content_item.status = session[:content_item_status]
        format.html { render :edit }
        format.json { render json: @guide.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guides/1
  # DELETE /guides/1.json
  def destroy
    @guide.destroy
    respond_to do |format|
      format.html { redirect_to :delete, flash: { message: 'Guide was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private

  def create_guide
    prepare_created_for(@guide)
    @guide.save
  end

  def update_guide
    prepare_update_for(@guide)
    @guide.update(guide_params)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_guide
    @guide = Guide.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def guide_params
    params[:guide].permit(:subtype,
                          :call_to_action_type,
                          :call_to_action_label,
                          :call_to_action_content,
                          :call_to_action_reason,
                          :contact_name,
                          :contact_email,
                          :contact_phone,
                          :featured_image,
                          :featured_image_alt,
                          :featured_image_caption,
                          :object_title,
                          :object_embed_code,
                          sections_attributes: [:id,
                                                :title,
                                                :body_content,
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
