class CollectionsController < ApplicationController
  skip_before_action :check_authorization
  before_action :check_admin_authorization
  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  before_action :set_pinned_item_list, only: [:edit, :update]
  before_action only: [:new, :edit] { status_for(@collection) }

  # GET /collections/1
  # GET /collections/1.json
  def show
  end

  # GET /collections/new
  def new
    @collection = Collection.new
    @collection.content_item = ContentItem.new
  end

  # GET /collections/1/edit
  def edit
    1.times { @collection.collection_sections.new }
    @collection.collection_sections.each do |section|
      (6 - section.section_items.size).times { section.section_items.new }
    end
  end

  # POST /collections
  # POST /collections.json
  def create
    @collection = Collection.new(collection_params)

    respond_to do |format|
      action_message_for('new')
      if create_collection
        format.html { redirect_to redirect_target(@collection), flash: @feedback_flash }
        format.json { render :show, status: :created, location: @collection }
      else
        format.html { render :new }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    respond_to do |format|
      action_message_for(@collection.content_item.status)
      if update_collection
        format.html { redirect_to redirect_target(@collection), flash: @feedback_flash }
        format.json { render :show, status: :ok, location: @collection }
      else
        1.times { @collection.collection_sections.new } if @collection.collection_sections.empty?
        @collection.collection_sections.each do |section|
          (6 - section.section_items.size).times { section.section_items.new }
        end
        @collection.content_item.status = session[:content_item_status]
        format.html { render :edit }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    @collection.destroy
    respond_to do |format|
      format.html { redirect_to :delete, flash: { message: 'Collection was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private

  def create_collection
    prepare_created_for(@collection)
    @collection.save
  end

  def update_collection
    prepare_update_for(@collection)
    @collection.update(collection_params)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_collection
    @collection = Collection.find(params[:id])
  end

  def set_pinned_item_list
    # Get all pinnable items, removing this Collection
    @pinned_item_list = ContentItem.all_pinnable_by_labels(@collection.content_item.labels) - [@collection.content_item]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def collection_params
    params.require(:collection).permit(collection_sections_attributes: [:id,
                                                                        :_destroy,
                                                                        :title,
                                                                        :summary,
                                                                        section_items_attributes: [:id,
                                                                                                   :item_order,
                                                                                                   :content_item_id]],
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
