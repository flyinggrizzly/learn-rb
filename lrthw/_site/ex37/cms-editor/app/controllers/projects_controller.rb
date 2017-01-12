class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action only: [:new, :edit] { status_for(@project) }

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
    @project.content_item = ContentItem.new
    1.times { @project.phases.new }
    1.times { @project.partners.new }
  end

  # GET /projects/1/edit
  def edit
    1.times { @project.phases.new }
    1.times { @project.partners.new }
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      action_message_for('new')
      if create_project
        format.html { redirect_to redirect_target(@project), flash: @feedback_flash }
        format.json { render :show, status: :created, location: @project }
      else
        1.times { @project.phases.new } if @project.phases.size == 0
        1.times { @project.partners.new } if @project.partners.size == 0
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      action_message_for(@project.content_item.status)
      if update_project
        format.html { redirect_to redirect_target(@project), flash: @feedback_flash }
        format.json { render :show, status: :ok, location: @project }
      else
        1.times { @project.phases.new } if @project.phases.size == 0
        1.times { @project.partners.new } if @project.partners.size == 0
        @project.content_item.status = session[:content_item_status]
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to :delete, flash: { message: 'Project was successfully deleted.' } }
      format.json { head :no_content }
    end
  end

  private

  def create_project
    prepare_created_for(@project)
    @project.save
  end

  def update_project
    prepare_update_for(@project)
    @project.update(project_params)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:subtype,
                                    :status,
                                    :project_overview,
                                    :budget,
                                    :start,
                                    :end,
                                    :contact_name,
                                    :contact_email,
                                    :contact_phone,
                                    :featured_image,
                                    :featured_image_alt,
                                    :featured_image_caption,
                                    :object_title,
                                    :object_embed_code,
                                    phases_attributes: [:id,
                                                        :title,
                                                        :summary,
                                                        :start,
                                                        :end,
                                                        :budget,
                                                        :_destroy],
                                    partners_attributes: [:id,
                                                          :name,
                                                          :logo_url,
                                                          :logo_alt,
                                                          :link_url,
                                                          :link_text,
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
