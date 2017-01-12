class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action only: [:new, :edit] { status_for(@event) }

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @event.content_item = ContentItem.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      action_message_for('new')
      if create_event
        format.html { redirect_to redirect_target(@event), flash: @feedback_flash }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      action_message_for(@event.content_item.status)
      if update_event
        format.html { redirect_to redirect_target(@event), flash: @feedback_flash }
        format.json { render :show, status: :ok, location: @event }
      else
        @event.content_item.status = session[:content_item_status]
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to :delete, flash: { message: 'Event was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private

  def create_event
    prepare_created_for(@event)
    @event.save
  end

  def update_event
    prepare_update_for(@event)
    @event.update(event_params)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:subtype,
                                  :start,
                                  :end,
                                  :location,
                                  :venue,
                                  :room_number,
                                  :building,
                                  :address_1,
                                  :address_2,
                                  :town,
                                  :postcode,
                                  :country,
                                  :accessibility,
                                  :audience,
                                  :audience_detail,
                                  :description,
                                  :speaker_profile,
                                  :booking_method,
                                  :booking_email,
                                  :booking_link,
                                  :charge,
                                  :price,
                                  :featured_image,
                                  :featured_image_caption,
                                  :featured_image_alt,
                                  :hashtag,
                                  :contact_name,
                                  :contact_email,
                                  :contact_phone,
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
