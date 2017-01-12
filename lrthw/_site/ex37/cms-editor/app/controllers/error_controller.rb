class ErrorController < ApplicationController
  skip_before_action :check_authentication

  def index
    if defined? session[:error_message]
      @error_message = session[:error_message]
      session[:error_message] = nil
    end
  end

  def no_permissions
  end
end
