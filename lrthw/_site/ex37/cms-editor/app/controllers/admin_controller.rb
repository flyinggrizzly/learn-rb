class AdminController < ApplicationController
  skip_before_action :check_authorization
  before_action :check_admin_authorization
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def delete
    @content_items = ContentItem.includes(:core_data).all.order('lower(title) ASC')
  end
end
