class ExternalItemsController < ApplicationController
  before_action :set_external_item, only: [:show, :edit, :update, :destroy]
  before_action only: [:new, :edit] { status_for(@external_item) }

  # GET /external_items/1
  # GET /external_items/1.json
  def show
  end

  # GET /external_items/new
  def new
    @external_item = ExternalItem.new
    @external_item.content_item = ContentItem.new
  end

  # GET /external_items/1/edit
  def edit
  end

  # POST /external_items
  # POST /external_items.json
  def create
    @external_item = ExternalItem.new(external_item_params)

    respond_to do |format|
      action_message_for('new')
      if create_external_item
        format.html { redirect_to redirect_target(@external_item), flash: @feedback_flash }
        format.json { render :show, status: :created, location: @external_item }
      else
        format.html { render :new }
        format.json { render json: @external_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /external_items/1
  # PATCH/PUT /external_items/1.json
  def update
    respond_to do |format|
      action_message_for(@external_item.content_item.status)
      if update_external_item
        format.html { redirect_to redirect_target(@external_item), flash: @feedback_flash }
        format.json { render :show, status: :ok, location: @external_item }
      else
        @external_item.content_item.status = session[:content_item_status]
        format.html { render :edit }
        format.json { render json: @external_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /external_items/1
  # DELETE /external_items/1.json
  def destroy
    @external_item.destroy
    respond_to do |format|
      format.html { redirect_to :delete, flash: { message: 'External item was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private

  def create_external_item
    prepare_created_for(@external_item)
    @external_item.save
  end

  def update_external_item
    prepare_update_for(@external_item)
    @external_item.update(external_item_params)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_external_item
    @external_item = ExternalItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def external_item_params
    params.require(:external_item).permit(:subtype,
                                          :external_url,
                                          :featured_image,
                                          :featured_image_alt,
                                          :featured_image_caption,
                                          :last_published_version,
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
