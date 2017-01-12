class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_action only: [:new, :edit] { status_for(@location) }

  # GET /locations/1
  # GET /locations/1.json
  def show
  end

  # GET /locations/new
  def new
    @location = Location.new
    @location.content_item = ContentItem.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      action_message_for('new')
      if create_location
        format.html { redirect_to redirect_target(@location), flash: @feedback_flash }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      action_message_for(@location.content_item.status)
      if update_location
        format.html { redirect_to redirect_target(@location), flash: @feedback_flash }
        format.json { render :show, status: :ok, location: @location }
      else
        @location.content_item.status = session[:content_item_status]
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to :delete, flash: { message: 'Location was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private

  def create_location
    prepare_created_for(@location)
    @location.save
  end

  def update_location
    prepare_update_for(@location)
    @location.update(location_params)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_location
    @location = Location.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def location_params
    params.require(:location).permit(:subtype,
                                     :on_off_campus,
                                     :building,
                                     :room,
                                     :address_1,
                                     :address_2,
                                     :town,
                                     :postcode,
                                     :country,
                                     :latitude,
                                     :longitude,
                                     :accessibility,
                                     :additional_information,
                                     :featured_image,
                                     :featured_image_alt,
                                     :featured_image_caption,
                                     :map_embed_code,
                                     :contact_name,
                                     :contact_email,
                                     :contact_phone,
                                     :opening_time_monday,
                                     :opening_time_tuesday,
                                     :opening_time_wednesday,
                                     :opening_time_thursday,
                                     :opening_time_friday,
                                     :opening_time_saturday,
                                     :opening_time_sunday,
                                     :opening_time_notes,
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
