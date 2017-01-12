class PublicationsController < ApplicationController
  before_action :set_publication, only: [:show, :edit, :update, :destroy]
  before_action only: [:new, :edit] { status_for(@publication) }

  # GET /publications/1
  # GET /publications/1.json
  def show
  end

  # GET /publications/new
  def new
    @publication = Publication.new
    @publication.content_item = ContentItem.new
    1.times { @publication.publication_attachments.new }
  end

  # GET /publications/1/edit
  def edit
    1.times { @publication.publication_attachments.new }
  end

  # POST /publications
  # POST /publications.json
  def create
    @publication = Publication.new(publication_params)

    respond_to do |format|
      action_message_for('new')
      if create_publication
        format.html { redirect_to redirect_target(@publication), flash: @feedback_flash }
        format.json { render :show, status: :created, location: @publication }
      else
        1.times { @publication.publication_attachments.new }
        format.html { render :new }
        format.json { render json: @publication.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /publications/1
  # PATCH/PUT /publications/1.json
  def update
    respond_to do |format|
      action_message_for(@publication.content_item.status)
      if update_publication
        format.html { redirect_to redirect_target(@publication), flash: @feedback_flash }
        format.json { render :show, status: :ok, location: @publication }
      else
        @publication.content_item.status = session[:content_item_status]
        format.html { render :edit }
        format.json { render json: @publication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /publications/1
  # DELETE /publications/1.json
  def destroy
    @publication.destroy
    respond_to do |format|
      format.html { redirect_to :delete, flash: { message: 'Publication was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private

  def create_publication
    prepare_created_for(@publication)
    @publication.save
  end

  def update_publication
    prepare_update_for(@publication)
    @publication.update(publication_params)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_publication
    @publication = Publication.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def publication_params
    params.require(:publication).permit(:subtype,
                                        :additional_info,
                                        :contact_name,
                                        :contact_email,
                                        :contact_phone,
                                        :restricted,
                                        publication_attachments_attributes: [:id,
                                                                             :attachment,
                                                                             :attachment_cache,
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
