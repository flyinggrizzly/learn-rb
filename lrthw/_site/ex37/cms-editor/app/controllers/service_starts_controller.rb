class ServiceStartsController < ApplicationController
  before_action :set_service_start, only: [:show, :edit, :update, :destroy]
  before_action only: [:new, :edit] { status_for(@service_start) }

  # GET /service_starts/1
  # GET /service_starts/1.json
  def show
  end

  # GET /service_starts/new
  def new
    @service_start = ServiceStart.new
    @service_start.content_item = ContentItem.new
  end

  # GET /service_starts/1/edit
  def edit
  end

  # POST /service_starts
  # POST /service_starts.json
  def create
    @service_start = ServiceStart.new(service_start_params)

    respond_to do |format|
      action_message_for('new')
      if create_service_start
        format.html { redirect_to redirect_target(@service_start), flash: @feedback_flash }
        format.json { render :show, status: :created, location: @service_start }
      else
        format.html { render :new }
        format.json { render json: @service_start.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /service_starts/1
  # PATCH/PUT /service_starts/1.json
  def update
    respond_to do |format|
      action_message_for(@service_start.content_item.status)
      if update_service_start
        format.html { redirect_to redirect_target(@service_start), flash: @feedback_flash }
        format.json { render :show, status: :ok, location: @service_start }
      else
        @service_start.content_item.status = session[:content_item_status]
        format.html { render :edit }
        format.json { render json: @service_start.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /service_starts/1
  # DELETE /service_starts/1.json
  def destroy
    @service_start.destroy
    respond_to do |format|
      format.html { redirect_to :delete, flash: { message: 'Service start was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private

  def create_service_start
    prepare_created_for(@service_start)
    @service_start.save
  end

  def update_service_start
    prepare_update_for(@service_start)
    @service_start.update(service_start_params)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_service_start
    @service_start = ServiceStart.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def service_start_params
    params.require(:service_start).permit(:usage_instructions,
                                          :call_to_action_type,
                                          :call_to_action_label,
                                          :call_to_action_content,
                                          :call_to_action_reason,
                                          :contact_name,
                                          :contact_email,
                                          :contact_phone,
                                          guide_ids: [],
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
