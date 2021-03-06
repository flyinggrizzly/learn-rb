class OrganisationsController < ApplicationController
  skip_before_action :check_authorization
  before_action :check_admin_authorization
  before_action :set_organisation, only: [:show, :edit, :update, :destroy]

  # GET /organisations
  # GET /organisations.json
  def index
    @organisations = Organisation.where(type: nil).order(name: :asc)
  end

  # GET /organisations/1
  # GET /organisations/1.json
  def show
  end

  # GET /organisations/new
  def new
    @organisation = Organisation.new
    @users = User.all
  end

  # GET /organisations/1/edit
  def edit
  end

  # POST /organisations
  # POST /organisations.json
  def create
    @organisation = Organisation.new(organisation_params)

    respond_to do |format|
      if @organisation.save
        format.html { redirect_to @organisation, notice: 'Organisation was successfully created.' }
        format.json { render :show, status: :created, location: @organisation }
      else
        format.html { render :new }
        format.json { render json: @organisation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organisations/1
  # PATCH/PUT /organisations/1.json
  def update
    respond_to do |format|
      if update_organisation
        format.html { redirect_to @organisation, notice: 'Organisation was successfully updated.' }
        format.json { render :show, status: :ok, location: @organisation }
      else
        format.html { render :edit }
        format.json { render json: @organisation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organisations/1
  # DELETE /organisations/1.json
  def destroy
    @organisation.destroy
    respond_to do |format|
      format.html { redirect_to organisations_url, notice: 'Organisation was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_organisation
    @organisation = Organisation.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def organisation_params
    params[:organisation].permit(:name, :contact_information, org_user_ids: [])
  end

  def associated_org_params
    params[:organisation].permit(:name, :contact_information)
  end

  def update_organisation
    @organisation.assign_attributes(organisation_params)

    Organisation.transaction do
      @organisation.update(organisation_params)
    end
  end
end
