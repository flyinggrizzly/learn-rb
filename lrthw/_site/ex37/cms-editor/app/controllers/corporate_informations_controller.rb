class CorporateInformationsController < ApplicationController
  before_action :set_corporate_information, only: [:show, :edit, :update, :destroy]
  before_action only: [:new, :edit] { status_for(@corporate_information) }

  # GET /corporate_informations/1
  # GET /corporate_informations/1.json
  def show
  end

  # GET /corporate_informations/new
  def new
    @corporate_information = CorporateInformation.new
    @corporate_information.content_item = ContentItem.new
  end

  # GET /corporate_informations/1/edit
  def edit
  end

  # POST /corporate_informations
  # POST /corporate_informations.json
  def create
    @corporate_information = CorporateInformation.new(corporate_information_params)

    respond_to do |format|
      action_message_for('new')
      if create_corporate_information
        format.html { redirect_to redirect_target(@corporate_information), flash: @feedback_flash }
        format.json { render :show, status: :created, location: @corporate_information }
      else
        format.html { render :new }
        format.json { render json: @corporate_information.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /corporate_informations/1
  # PATCH/PUT /corporate_informations/1.json
  def update
    respond_to do |format|
      action_message_for(@corporate_information.content_item.status)
      if update_corporate_information
        format.html { redirect_to redirect_target(@corporate_information), flash: @feedback_flash }
        format.json { render :show, status: :ok, location: @corporate_information }
      else
        @corporate_information.content_item.status = session[:content_item_status]
        format.html { render :edit }
        format.json { render json: @corporate_information.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /corporate_informations/1
  # DELETE /corporate_informations/1.json
  def destroy
    @corporate_information.destroy
    respond_to do |format|
      format.html { redirect_to :delete, flash: { message: 'Corporate information was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private

  def create_corporate_information
    prepare_created_for(@corporate_information)
    @corporate_information.save
  end

  def update_corporate_information
    prepare_update_for(@corporate_information)
    @corporate_information.update(corporate_information_params)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_corporate_information
    @corporate_information = CorporateInformation.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def corporate_information_params
    params.require(:corporate_information).permit(:subtype,
                                                  :body_content,
                                                  :featured_image,
                                                  :featured_image_alt,
                                                  :featured_image_caption,
                                                  :object_title,
                                                  :object_embed_code,
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
