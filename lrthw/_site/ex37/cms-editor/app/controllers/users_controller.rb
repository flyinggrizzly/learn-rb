class UsersController < ApplicationController
  skip_before_action :check_authorization
  before_action :check_admin_authorization
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @cms_users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @cms_user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @cms_user = User.new(user_params)

    respond_to do |format|
      if @cms_user.save
        Rails.logger.info "#{current_user.username} created #{@cms_user.username}"
        format.html { redirect_to @cms_user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @cms_user }
      else
        Rails.logger.error "#{current_user.username} creating #{@cms_user.username} FAILED"
        format.html { render :new }
        format.json { render json: @cms_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @cms_user.update(user_params)
        Rails.logger.info "#{current_user.username} updated #{@cms_user.username}"
        format.html { redirect_to @cms_user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @cms_user }
      else
        Rails.logger.error "#{current_user.username} updating #{@cms_user.username} FAILED"
        format.html { render :edit }
        format.json { render json: @cms_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @cms_user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @cms_user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:display_name,
                                 :first_name,
                                 :last_name,
                                 :username,
                                 :organisation_id,
                                 group_ids: [],
                                 associated_org_ids: [])
  end
end
