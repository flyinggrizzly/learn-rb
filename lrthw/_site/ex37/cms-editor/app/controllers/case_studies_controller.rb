class CaseStudiesController < ApplicationController
  before_action :set_case_study, only: [:show, :edit, :update, :destroy]
  before_action only: [:new, :edit] { status_for(@case_study) }

  # GET /case_studies/1
  # GET /case_studies/1.json
  def show
  end

  # GET /case_studies/new
  def new
    @case_study = CaseStudy.new
    @case_study.content_item = ContentItem.new
  end

  # GET /case_studies/1/edit
  def edit
  end

  # POST /case_studies
  # POST /case_studies.json
  def create
    @case_study = CaseStudy.new(case_study_params)

    respond_to do |format|
      action_message_for('new')
      if create_case_study
        format.html { redirect_to redirect_target(@case_study), flash: @feedback_flash }
        format.json { render :show, status: :created, location: @case_study }
      else
        format.html { render :new }
        format.json { render json: @case_study.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /case_studies/1
  # PATCH/PUT /case_studies/1.json
  def update
    respond_to do |format|
      action_message_for(@case_study.content_item.status)
      if update_case_study
        format.html { redirect_to redirect_target(@case_study), flash: @feedback_flash }
        format.json { render :show, status: :ok, location: @case_study }
      else
        @case_study.content_item.status = session[:content_item_status]
        format.html { render :edit }
        format.json { render json: @case_study.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /case_studies/1
  # DELETE /case_studies/1.json
  def destroy
    @case_study.destroy
    respond_to do |format|
      format.html { redirect_to :delete, flash: { message: 'Case study was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private

  def create_case_study
    prepare_created_for(@case_study)
    @case_study.save
  end

  def update_case_study
    prepare_update_for(@case_study)
    @case_study.update(case_study_params)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_case_study
    @case_study = CaseStudy.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def case_study_params
    params.require(:case_study).permit(:subtype,
                                       :body_content,
                                       :quote,
                                       :quote_attribution,
                                       :featured_image,
                                       :featured_image_alt,
                                       :featured_image_caption,
                                       :object_title,
                                       :object_embed_code,
                                       :call_to_action_type,
                                       :call_to_action_label,
                                       :call_to_action_content,
                                       :call_to_action_reason,
                                       :contact_name,
                                       :contact_email,
                                       :contact_phone,
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
